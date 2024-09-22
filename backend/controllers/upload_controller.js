const multer = require('multer');
const path = require('path');
const fs = require('fs');
const pool = require('../db');

// Set up storage engine
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    const dir = './uploads/profile_pictures';
    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir);
    }
    cb(null, dir);
  },
  filename: (req, file, cb) => {
    cb(null, `${Date.now()}${path.extname(file.originalname)}`);
  }
});

// Initialize multer upload
const upload = multer({
  storage: storage,
  limits: { fileSize: 5000000 },
  fileFilter: (req, file, cb) => {
    checkFileType(file, cb);
  }
}).single('profile_picture');

// Check file type
function checkFileType(file, cb) {
  const filetypes = /jpeg|jpg|png|gif/;
  const extname = filetypes.test(path.extname(file.originalname).toLowerCase());
  const mimetype = filetypes.test(file.mimetype);

  if (mimetype && extname) {
    return cb(null, true);
  } else {
    cb('Error: Images Only!');
  }
}

// Controller function to upload an image
exports.uploadImage = (req, res) => {
  const token = req.params.token;
  if (!token) {
    return res.status(401).json({ message: 'No token provided' });
  }
  // Step 1: Validate the Token and Get school_id
  pool.getConnection((error, connection) => {
    if (error) {
      console.error('Error getting MySQL connection:', error);
      return res.status(500).json({ message: 'Server error occurred' });
    }
    connection.query('SELECT school_id FROM users WHERE token = ?', [token], (error, userResult) => {
      if (error) {
        connection.release();
        console.error('Error executing query:', error);
        return res.status(500).json({ message: 'Server error occurred' });
      }
      if (userResult.length === 0) {
        connection.release();
        return res.status(403).json({ message: 'Invalid token' });
      }
      const schoolId = userResult[0].school_id;
      req.schoolId = schoolId;
      // Perform file upload
      upload(req, res, (err) => {
        connection.release();
        if (err) {
          return res.status(400).json({ message: err.message });
        }
        if (req.file === undefined) {
          return res.status(400).json({ message: 'No file selected!' });
        }
        // Update the user's profile picture path in the database
        const filePath = req.file.filename;
        pool.query('UPDATE users SET profile_picture = ? WHERE school_id = ?', [filePath, req.schoolId], (err, results) => {
          if (err) {
            return res.status(500).json({ message: 'Database update failed' });
          }
          res.status(200).json({
            message: 'Profile picture updated successfully',
            filePath: `/uploads/profile_pictures/${filePath}`
          });
        });
      });
    });
  });
};
