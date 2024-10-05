const mongoose = require('mongoose');

const scheduleSchema = new mongoose.Schema({
  school_id: { type: String, required: true },
  room: { type: String, required: true },
  block: { type: String, required: true },
  subject: { type: String, required: true },
  prof_id: { type: String, required: true, index: true }, 
  professor: { type: String, required: true },
  department: { type: String, required: true },
  time: { type: String, required: true },
  date: { type: String, required: true },  
  completed: { type: String, default: 'pending' }  
}, { timestamps: true });  
const Schedule = mongoose.model('Schedule', scheduleSchema);

module.exports = Schedule;
