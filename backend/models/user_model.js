const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  school_id: { type: String, required: true, index: { unique: true} },
  email: { type: String, required: true, index: true },
  password: { type: String, required: true },
  first_name: { type: String, required: true },
  middle_name: { type: String, required: false },
  last_name: { type: String, required: true },
  profile_picture: { type: String, default: null }, 
  gender: { type: String, required: true },
  contact: { type: String, required: true },
  address: { type: String, required: true },
  role: { type: String, required: true },
  professor: { type: String, required: false, default: null},
  hk_type: { type: String, required: false },
  status: { type: String, required: true },
  token: { type: String, required: false }
}, { timestamps: true });

const User = mongoose.model('User', userSchema, 'users');

module.exports = User;
