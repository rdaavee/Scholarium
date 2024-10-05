const mongoose = require('mongoose');

const dtrSchema = new mongoose.Schema({
  school_id: { type: String, required: true },        
  date: { type: Date, required: true },              
  time_in: { type: String, required: true },           
  time_out: { type: String, required: true },         
  hours_to_rendered: { type: Number, required: true },  
  hours_rendered: { type: Number, required: true },     
  professor: { type: String, required: true },         
  professor_signature: { type: String, required: true }
}, { timestamps: true });

const DTR = mongoose.model('DTR', dtrSchema);

module.exports = DTR;
