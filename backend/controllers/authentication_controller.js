const jwt = require("jsonwebtoken");
const User = require("../models/user_model");
const Message = require("../models/message_system_model");
const crypto = require("crypto");
const { sendVerificationCode } = require("../services/mailService");
const secretKey = process.env.SECRET_KEY;
//=========================================PASSWORD AUTHENTICATION=====================================================================
const verificationCodes = {};

// Forgot Password - Request Code
exports.forgotPassword = async (req, res) => {
  const { email } = req.body;

  if (!email) {
    return res.status(400).json({ message: "Email is required." });
  }

  const user = await User.findOne({ email });
  if (!user) {
    return res.status(404).json({ message: "User not found." });
  }

  const code = crypto.randomInt(100000, 999999).toString();
  verificationCodes[email] = code;

  await sendVerificationCode(email, code);

  res.status(200).json({ message: "Verification code sent to your email." });
};

// Verify Code
exports.verifyCode = async (req, res) => {
  const { email, code } = req.body;

  console.log(email);
  console.log(code);
  if (verificationCodes[email] == code) {
    console.log("OTP successful.");
    res.status(200).json({ message: "OTP successful." });
  } else {
    console.log("OTP mali.");
    return res.status(400).json({ message: "Invalid or expired code." });
  }
};

// Verify Code and Reset Password
exports.resetPassword = async (req, res) => {
  const { email, newPassword } = req.body;

  const user = await User.findOne({ email });
  if (!user) {
    return res.status(404).json({ message: "User not found." });
  }

  // Update user password without hashing
  user.password = newPassword;
  await user.save();

  delete verificationCodes[email];

  res.status(200).json({ message: "Password reset successful." });
};

// Login
exports.login = async (req, res) => {
  try {
    const { school_id, password } = req.body;

    const user = await User.findOne({ school_id: school_id.trim() });

    if (!user) {
      return res.status(401).json({ message: "Invalid school ID or password" });
    }

    // Compare the plaintext password
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
        status: user.status
      });
    } else {
      res.status(401).json({ message: "Invalid school ID or password" });
    }
  } catch (error) {
    console.error("Error in login:", error);
    res.status(500).json({ message: "Server error occurred" });
  }
};

//========================================================MESSAGING SYSTEM============================================================
// authentication_controller.js

exports.postMessage = async (req, res) => {
  try {
    const io = req.app.get('io');
    const { sender, receiver, content } = req.body;

    const senderUser = await User.findOne({ school_id: sender });
    const receiverUser = await User.findOne({ school_id: receiver });

    if (!senderUser || !receiverUser) {
      return res.status(404).json({ message: "Sender or receiver not found" });
    }

    const message = new Message({
      sender: senderUser._id,
      receiver: receiverUser._id,
      content,
    });

    await message.save();

    // Emit the message to the receiver through socket.io
    const receiverSocketId = connectedUsers[receiverUser.school_id];
    if (receiverSocketId) {
      io.to(receiverSocketId).emit("receiveMessage", {
        sender: senderUser.school_id,
        content: message.content,
        timestamp: message.createdAt,
      });
      console.log(`Message sent from ${senderUser.school_id} to ${receiverUser.school_id}: ${message.content}`);
    } else {
      console.error(`Receiver ${receiverUser.school_id} is not connected.`);
      return res.status(404).json({ message: "Receiver is not connected." });
    }

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

    const senderUser = await User.findOne({ school_id: sender });
    const receiverUser = await User.findOne({ school_id: receiver });

    if (!senderUser || !receiverUser) {
      return res.status(404).json({ message: "User not found" });
    }

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

// Fetch all unique receivers the sender has communicated with
exports.getReceiversBySender = async (req, res) => {
  try {
    const loggedInProfId = req.userSchoolId; // Assuming req.userSchoolId is the logged-in user's ID

    const uniqueReceivers = await Message.find({
      sender: loggedInProfId,
    }).distinct("receiver");

    if (uniqueReceivers.length === 0) {
      return res
        .status(404)
        .json({ message: "No receivers found for this professor." });
    }

    res.status(200).json({ receivers: uniqueReceivers });
  } catch (error) {
    console.error("Error fetching receivers:", error);
    res
      .status(500)
      .json({ message: "Server error. Unable to fetch receivers." });
  }
};
