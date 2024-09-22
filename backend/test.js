const mongoose = require('mongoose');
require('dotenv').config();

const mongoURI = "mongodb+srv://general_user:ishkolarium2024@cluster0.hhmgu.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";
console.log('MongoDB URI:', mongoURI);

const testConnection = async () => {
  try {
    await mongoose.connect(mongoURI);
    console.log("MongoDB connected successfully");
    mongoose.connection.close();
  } catch (err) {
    console.error("Error connecting to MongoDB:", err.message);
  }
};

testConnection();
