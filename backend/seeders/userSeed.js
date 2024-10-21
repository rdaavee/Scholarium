const mongoose = require("mongoose");
const User = require("../models/user_model"); // Adjust the path as needed
require("dotenv").config();
const mongoURI = process.env.MONGODB_URI;

const seedUsers = async () => {
  try {
    // Connect to MongoDB
    await mongoose.connect(mongoURI);

    // Clear existing users
    await User.deleteMany({});

    // Sample user data with professor field for Student role
    const users = [
      {
        school_id: "00-0000-00000",
        email: "reminderbot@phinmaed.com",
        password: "0",
        first_name: "Reminder",
        middle_name: "",
        last_name: "Bot",
        profile_picture: null,
        gender: "Male",
        contact: "0000-000-0000",
        address: "Server",
        role: "Admin",
        hk_type: "",
        status: "Active",
        token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MzYsI...",
      },
      {
        school_id: "03-0000-00004",
        email: "benedict@phinmaed.com",
        password: "4",
        first_name: "Mark Benedict",
        middle_name: "C.",
        last_name: "Abalos",
        profile_picture: null,
        gender: "Male",
        contact: "09516185235",
        address: "Baybay Polong",
        role: "Student",
        hk_type: "HK 25",
        status: "Active",
        token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MzQsI...",
        professor: "03-0000-00002", 
      },
      {
        school_id: "03-0000-00002",
        email: "david@phinmaed.com",
        password: "2",
        first_name: "David Aldrin",
        middle_name: "F.",
        last_name: "Mondero",
        profile_picture: null,
        gender: "Male",
        contact: "0900-000-0002",
        address: "456 Oak St",
        role: "Professor",
        hk_type: "",
        status: "Active",
        token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MzUsI...",
      },
      {
        school_id: "03-0000-00003",
        email: "ranier@phinmaed.com",
        password: "3",
        first_name: "Ranier Dave",
        middle_name: "T.",
        last_name: "Arcega",
        profile_picture: null,
        gender: "Male",
        contact: "0900-000-0003",
        address: "789 Pine St",
        role: "Admin",
        status: "Active",
        token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MzYsI...",
      },
      {
        school_id: "03-0000-00001",
        email: "olib@phinmaed.com",
        password: "1",
        first_name: "John Oliver",
        middle_name: "I.",
        last_name: "Ferrer",
        profile_picture: null,
        gender: "Male",
        contact: "0900-000-0003",
        address: "789 Pine St",
        role: "Student",
        hk_type: "HK 50",
        status: "Active",
        token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MzYsI...",
        professor: "David Aldrin Mondero",
        prof_id: "03-0000-00002",
      },


    ];

    // Insert the sample data
    await User.insertMany(users);

    console.log("Seed data inserted successfully");
  } catch (error) {
    console.error("Error seeding data:", error);
  } finally {
    // Close the connection
    mongoose.connection.close();
  }
};

// Run the seed function
seedUsers();
