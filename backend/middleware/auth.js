const jwt = require('jsonwebtoken');
const secretKey = process.env.SECRET_KEY; // Load the secret key from environment variables

module.exports = (req, res, next) => {
  const token = req.headers['authorization'];

  if (!token) {
    return res.status(403).json({ message: 'No token provided' });
  }

  jwt.verify(token, secretKey, (error, decoded) => {
    if (error) {
      return res.status(500).json({ message: 'Failed to authenticate token' });
    }

    req.userId = decoded.id;
    next();
  });
};
