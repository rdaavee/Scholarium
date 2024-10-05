const mongoose = require('mongoose');


const eventsSchema = new mongoose.Schema({
  name_of_event: { type: String, required: true }, 
  images: { type: String },                        
  description: { type: String },                   
  date: { type: String, required: true },          
  time: { type: String, required: true }           
}, { timestamps: true }); 


const Events = mongoose.model('Event', eventsSchema);

module.exports = Events;
