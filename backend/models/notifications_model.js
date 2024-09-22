const mongoose = require('mongoose');


const notificationsSchema = new mongoose.Schema({
  school_id: { type: String, required: true }, 
  sender: { type: String, required: true },     
  role: { type: String, required: true },       
  message: { type: String, required: true },   
  status: { 
    type: String, 
    default: 'unread'
  },
  date: { type: String, required: true }, 
  time: { type: String, required: true }   
}, { timestamps: true }); 

const Notifications = mongoose.model('Notification', notificationsSchema);

module.exports = Notifications;
