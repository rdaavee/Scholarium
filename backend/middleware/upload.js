const multer = require('multer');
const storage = multer.memoryStorage(); 

// Create the upload middleware
const upload = multer({
  storage,
  limits: {
    fileSize: 5 * 1024 * 1024, 
  },
  fileFilter: (req, file, cb) => {
    const filetypes = /jpeg|jpg|png|gif/; 
    const mimetype = filetypes.test(file.mimetype); 
    const extname = filetypes.test(file.originalname.split('.').pop().toLowerCase()); 

    if (mimetype && extname) {
      return cb(null, true);
    } else {
      cb(new Error('Error: Only images are allowed!')); 
    }
  },
});


module.exports = upload;
