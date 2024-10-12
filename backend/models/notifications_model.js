const mongoose = require('mongoose');


const notificationsSchema = new mongoose.Schema({
  sender: { type: String, required: true },     
  senderName: { type: String, required: true },   
  receiver: { type:String, index: true, default: null  }, 
  receiverName: { type:String, index: true, default: null  }, 
  role: { type: String, required: true },   
  title: { type: String, required: true },     
  message: { type: String, required: true },   
  status: { 
    type: Boolean, 
    default: false
  },
  scheduleId: {type: String, required: false},
  isActive: { 
    type: Boolean, 
    default: false
  },
  date: { type: String, required: true }, 
  time: { type: String, required: true }   
}, { timestamps: true }); 

const Notifications = mongoose.model('Notification', notificationsSchema);

module.exports = Notifications;
