const mongoose = require('mongoose');

const postsSchema = new mongoose.Schema({
  title: { type: String, required: true }, 
  body: { type: String, required: true },   
  date: { type: Date, default: Date.now },  
  time: { type: String, default: null },
  status: { 
    type: String, 
    enum: ['Active', 'Inactive'], 
    default: 'Inactive'
  },
  school_id: { type: String, index: true, default: null } 
}, { timestamps: true }); 

const Posts = mongoose.model('Post', postsSchema);

module.exports = Posts;
