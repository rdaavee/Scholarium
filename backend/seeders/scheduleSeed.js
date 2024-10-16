const mongoose = require("mongoose");
const ClassSchedule = require("../models/schedule_model"); // Adjust the path as needed
require("dotenv").config();
const mongoURI = process.env.MONGODB_URI;

const seedClassSchedules = async () => {
  try {
    // Connect to MongoDB
    await mongoose.connect(mongoURI);

    // Clear existing class schedules
    await ClassSchedule.deleteMany({});

    // Sample class schedule data
    const schedules = [
      {
        school_id: "03-0000-00001",
        room: "Room 101",
        block: "Block A",
        subject: "Mathematics",
        prof_id: "03-0000-00002",
        professor: "David Aldrin Mondero",
        department: "CITE",
        isActive: true,
        time: "14:00:00",
        date: "2024-10-16",
        completed: "pending",      },
      {
        school_id: "03-0000-00001",
        room: "Room 101",
        block: "Block A",
        subject: "Mathematics",
        prof_id: "03-0000-00002",
        professor: "David Aldrin Mondero",
        department: "CITE",
        isActive: true,
        time: "15:00:00",
        date: "2024-9-11",
        completed: "pending",      },
      {
        school_id: "03-0000-00001",
        room: "Room 101",
        block: "Block A",
        subject: "Mathematics",
        prof_id: "03-0000-00002",
        professor: "David Aldrin Mondero",
        department: "CITE",
        isActive: true,
        time: "15:00:00",
        date: "2024-10-11",
        completed: "pending",      },
      {
        school_id: "03-0000-00001",
        room: "Room 101",
        block: "Block A",
        subject: "Mathematics",
        prof_id: "03-0000-00002",
        professor: "David Aldrin Mondero",
        department: "CITE",
        isActive: true,
        time: "15:00:00",
        date: "2024-10-11",
        completed: "pending",
      },
      {
        school_id: "03-0000-00001",
        room: "Room 101",
        block: "Block A",
        subject: "Mathematics",
        prof_id: "03-0000-00002",
        professor: "David Aldrin Mondero",
        department: "CITE",
        isActive: true,
        time: "15:00:00",
        date: "2024-10-11",
        completed: "pending",      },
    ];

    // Insert the sample data
    await ClassSchedule.insertMany(schedules);

    console.log("Seed data inserted successfully");
  } catch (error) {
    console.error("Error seeding data:", error);
  } finally {
    // Close the connection
    mongoose.connection.close();
  }
};

// Run the seed function
seedClassSchedules();
