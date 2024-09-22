const jwt = require('jsonwebtoken');
const User = require('../models/user_model');
const secretKey = process.env.SECRET_KEY;

exports.login = async (req, res) => {
  console.log("Login route hit");
  try {
    const { school_id, password } = req.body;
    const trimmedSchoolId = school_id.trim();

    console.log(`Searching for user with school_id: '${trimmedSchoolId}'`);
  

    const user = await User.findOne({ school_id: trimmedSchoolId })
    console.log(`Querying for user with school_id: '${trimmedSchoolId}'`);
;
    console.log('User found:', user);

    if (!user) {
      console.log('No user found with that school_id.');
      return res.status(401).json({ message: 'Invalid school ID or password' });
    }

    console.log('User password from DB:', user.password);
    
    if (user.password === password) {
      const token = jwt.sign(
        { id: user._id, school_id: user.school_id, role: user.role },
        secretKey,
        { expiresIn: '1h' }
      );

      user.token = token;
      await user.save();

      res.status(200).json({
        message: `Welcome, ${user.first_name} ${user.last_name}`,
        token: token,
        role: user.role
      });
    } else {
      console.log('Password mismatch');
      res.status(401).json({ message: 'Invalid school ID or password' });
    }
  } catch (error) {
    console.error('Error in login:', error);
    res.status(500).json({ message: 'Server error occurred' });
  }
};


