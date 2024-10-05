const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");
const User = require("../models/user_model");
const Message = require("../models/message_system_model");
const crypto = require("crypto");
const { sendVerificationCode } = require("../services/mailService");
const secretKey = process.env.SECRET_KEY;

const verificationCodes = {}; // Temporary storage for verification codes

// Forgot Password - Request Code
exports.forgotPassword = async (req, res) => {
  const { email } = req.body;

  if (!email) {
    return res.status(400).json({ message: "Email is required." });
  }

  // Check if user exists
  const user = await User.findOne({ email });
  if (!user) {
    return res.status(404).json({ message: "User not found." });
  }

  // Generate a verification code
  const code = crypto.randomInt(100000, 999999).toString();
  verificationCodes[email] = code;

  // Send code via email
  await sendVerificationCode(email, code);

  res.status(200).json({ message: "Verification code sent to your email." });
};

// Verify Code and Reset Password
exports.resetPassword = async (req, res) => {
  const { email, code, newPassword } = req.body;

  if (!email || !code || !newPassword) {
    return res.status(400).json({ message: "All fields are required." });
  }

  // Check if the code is correct
  if (verificationCodes[email] !== code) {
    return res.status(400).json({ message: "Invalid or expired code." });
  }

  // Find user and update password
  const user = await User.findOne({ email });
  if (!user) {
    return res.status(404).json({ message: "User not found." });
  }

  // Hash new password and update user
  const hashedPassword = await bcrypt.hash(newPassword, 10);
  user.password = hashedPassword;
  await user.save();

  // Delete the used verification code
  delete verificationCodes[email];

  res.status(200).json({ message: "Password reset successful." });
};

exports.login = async (req, res) => {
  console.log("Login route hit");
  try {
    const { school_id, password } = req.body;
    const trimmedSchoolId = school_id.trim();

    console.log(`Searching for user with school_id: '${trimmedSchoolId}'`);

    const user = await User.findOne({ school_id: trimmedSchoolId });
    console.log(`Querying for user with school_id: '${trimmedSchoolId}'`);
    console.log("User found:", user);

    if (!user) {
      console.log("No user found with that school_id.");
      return res.status(401).json({ message: "Invalid school ID or password" });
    }

    console.log("User password from DB:", user.password);

    if (user.password === password) {
      const token = jwt.sign(
        { id: user._id, school_id: user.school_id, role: user.role },
        secretKey,
        { expiresIn: "1h" }
      );

      user.token = token;
      await user.save();

      res.status(200).json({
        message: `Welcome, ${user.first_name} ${user.last_name}`,
        token: token,
        role: user.role,
      });
    } else {
      console.log("Password mismatch");
      res.status(401).json({ message: "Invalid school ID or password" });
    }
  } catch (error) {
    console.error("Error in login:", error);
    res.status(500).json({ message: "Server error occurred" });
  }
};

exports.postMessage = async (req, res) => {
  try {
      const { sender, receiver, content } = req.body;

      // Find sender and receiver users by their school_id
      const senderUser = await User.findOne({ school_id: sender });
      const receiverUser = await User.findOne({ school_id: receiver });

      // Check if both users exist
      if (!senderUser || !receiverUser) {
          return res.status(404).json({ message: "Sender or receiver not found" });
      }

      // Create the message with ObjectId references
      const message = new Message({
          sender: senderUser._id,
          receiver: receiverUser._id,
          content,
      });

      await message.save();
      console.log("Message sent successfully from " + sender + " to " + receiver);
      res.status(200).json({ message: "Message sent successfully" });
  } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Server error" });
  }
};


// Get messages between two users
exports.getMessages = async (req, res) => {
  try {
    const { sender, receiver } = req.params;

    // Find the sender and receiver by their school_id
    const senderUser = await User.findOne({ school_id: sender });
    const receiverUser = await User.findOne({ school_id: receiver });

    if (!senderUser || !receiverUser) {
      return res.status(404).json({ message: "User not found" });
    }

    // Query messages using the _id of the found users
    const messages = await Message.find({
      $or: [
        { sender: senderUser._id, receiver: receiverUser._id },
        { sender: receiverUser._id, receiver: senderUser._id },
      ],
    })
      .populate("sender", "first_name last_name school_id")
      .populate("receiver", "first_name last_name school_id");

    res.json(messages);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
};
