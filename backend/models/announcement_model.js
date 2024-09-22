const mongoose = require('mongoose');

const announcementSchema = new mongoose.Schema({
  admin_id: { type: String, required: true },      
  title: { type: String, required: true },           
  body: { type: String, required: true },           
  time: { type: String, required: true },         
  date: { type: String }                                
}, { timestamps: true });  

const Announcement = mongoose.model('Announcement', announcementSchema);

module.exports = Announcement;
