const multer = require('multer');
const path = require('path');
const bucket = require('../firebase'); // Firebase bucket
const { v4: uuidv4 } = require('uuid'); 
const User = require('../models/user_model'); 

// Set up multer for in-memory storage
const storage = multer.memoryStorage();
const upload = multer({
  storage: storage,
  limits: { fileSize: 5000000 }, // 5MB limit
  fileFilter: (req, file, cb) => {
    checkFileType(file, cb);
  }
}).single('profile_picture');

// Check file type
function checkFileType(file, cb) {
  const filetypes = /jpeg|jpg|png|gif/;
  const extname = filetypes.test(path.extname(file.originalname).toLowerCase());

  // Handle cases where MIME type is misinterpreted as 'application/octet-stream'
  const mimetype = file.mimetype.startsWith('image/') || file.mimetype === 'application/octet-stream';

  console.log('File MIME type:', file.mimetype);
  console.log('File Extension:', path.extname(file.originalname).toLowerCase());

  if (mimetype && extname) {
    return cb(null, true);
  } else {
    cb('Error: Only images are allowed!');
  }
}


// Controller function to upload an image
exports.uploadImage = async (req, res) => {
  if (!req.userId || !req.userSchoolId) {
    return res.status(401).json({ message: 'Unauthorized! No user information available.' });
  }
  console.log('User ID:', req.userId);
  console.log('School ID:', req.userSchoolId);
  console.log('File uploaded:', req.filePath);


  try {
    const schoolId = req.userSchoolId;
    req.schoolId = schoolId;

    upload(req, res, async (err) => {
      if (err) {
        console.error('Multer Error:', err);
        return res.status(400).json({ message: err.message });
      }

      console.log('Uploaded file:', req.file); // Log the uploaded file details

      if (!req.file) {
        return res.status(400).json({ message: 'No file selected!' });
      }

      const blob = bucket.file(`${uuidv4()}_${req.file.originalname}`);
      const blobStream = blob.createWriteStream({
        metadata: {
          contentType: req.file.mimetype,
        },
      });

      blobStream.on('error', (err) => {
        return res.status(500).json({ message: 'Upload error: ' + err.message });
      });

      blobStream.on('finish', async () => {
        const publicUrl = `https://storage.googleapis.com/${bucket.name}/${blob.name}`;
        await blob.makePublic();

        await User.updateOne({ school_id: req.schoolId }, { $set: { profile_picture: publicUrl } });
        res.status(200).json({
          message: 'Profile picture updated successfully',
          filePath: publicUrl,
        });
      });

      blobStream.end(req.file.buffer);
    });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ message: 'Server error occurred' });
  }
};
