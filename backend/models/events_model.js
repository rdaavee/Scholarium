const mongoose = require('mongoose');


const eventsSchema = new mongoose.Schema({
  image_link: { type: String },    
  event_name: { type: String, required: true },                     
  description: { type: String },                   
  date: { type: String, required: true },          
  time: { type: String, required: true }           
}, { timestamps: true }); 

const Events = mongoose.model('Event', eventsSchema);

module.exports = Events;
