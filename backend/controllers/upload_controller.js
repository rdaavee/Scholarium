const multer = require('multer');
const path = require('path');
const bucket = require('../firebase'); 
const { v4: uuidv4 } = require('uuid'); 
const User = require('../models/user_model'); 
const Events = require('../models/events_model');



const storage = multer.memoryStorage();
const upload = multer({
  storage: storage,
  limits: { fileSize: 5000000 }, // 5MB limit
  fileFilter: (req, file, cb) => {
    checkFileType(file, cb);
  }
}).single('profile_picture');

const event = multer({
  storage: storage,
  limits: { fileSize: 5000000 }, // 5MB limit
  fileFilter: (req, file, cb) => {
    checkFileType(file, cb);
  }
}).single('event_image');


function checkFileType(file, cb) {
  const filetypes = /jpeg|jpg|png|gif/;
  const extname = filetypes.test(path.extname(file.originalname).toLowerCase());
  const mimetype = file.mimetype.startsWith('image/') || file.mimetype === 'application/octet-stream';
  console.log('File MIME type:', file.mimetype);
  console.log('File Extension:', path.extname(file.originalname).toLowerCase());
  if (mimetype && extname) {
    return cb(null, true);
  } else {
    cb('Error: Only images are allowed!');
  }
}

exports.createEventWithImage = async (req, res) => {
  try {
    event(req, res, async (err) => {
      if (err) {
        console.error('Multer Error:', err);
        return res.status(400).json({ message: err.message });
      }

      const { event_name, description, date, time } = req.body;
      if (!event_name || !date || !time) {
        return res.status(400).json({ message: 'Event name, date, and time are required.' });
      }

      if (!req.file) {
        return res.status(400).json({ message: 'No image file selected!' });
      }

      let newEvent = new Events({
        event_name,
        description,
        date,
        time,
      });

      await newEvent.save();

      const blob = bucket.file(`${uuidv4()}_${req.file.originalname}`);
      const blobStream = blob.createWriteStream({
        metadata: {
          contentType: req.file.mimetype,
        },
      });

      blobStream.on('error', (err) => {
        console.error('Upload error:', err);
        return res.status(500).json({ message: 'Upload error: ' + err.message });
      });

      blobStream.on('finish', async () => {
        const publicUrl = `https://storage.googleapis.com/${bucket.name}/${blob.name}`;
        await blob.makePublic(); 

        newEvent.image_link = publicUrl;
        await newEvent.save();

        res.status(200).json({
          message: 'Event created and image uploaded successfully',
          event: newEvent,
        });
      });

      blobStream.end(req.file.buffer);
    });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ message: 'Server error occurred' });
  }
};

exports.uploadImage = async (req, res) => {

  try {
    upload(req, res, async (err) => {
      if (err) {
        console.error('Multer Error:', err);
        return res.status(400).json({ message: err.message });
      }
      console.log('Uploaded file:', req.file); 
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
        console.error('Upload error:', err);
        return res.status(500).json({ message: 'Upload error: ' + err.message });
      });
      blobStream.on('finish', async () => {
        const publicUrl = `https://storage.googleapis.com/${bucket.name}/${blob.name}`;
        await blob.makePublic(); 
        await User.updateOne({ school_id: req.userSchoolId }, { $set: { profile_picture: publicUrl } });
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