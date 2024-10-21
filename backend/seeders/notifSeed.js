const mongoose = require("mongoose");
const Notification = require("../models/notifications_model"); // Adjust the path as needed
require("dotenv").config();
const mongoURI = process.env.MONGODB_URI;

const seedNotifications = async () => {
  try {
    // Connect to MongoDB
    await mongoose.connect(mongoURI);

    // Clear existing notifications
    await Notification.deleteMany({});

    // Sample notification data
    const notifications = [
      {
        sender: "03-0000-00003",
        senderName: "Ranier Dave Arcega",
        receiver: "03-0000-00001",
        receiverName: "03-0000-00001",
        role: "Admin",
        title: "Schedule Duty",
        message:
          "You have been assigned a schedule to professor David Aldrin Mondero's class on Monday.",
        status: false,
        scheduleId: "",
        date: "2024-10-16",
        time: "15:19:27",
        createdAt: "2024-10-16T07:20:28.576+00:00",
        updatedAt: "2024-10-16T07:21:30.972+00:00",
        __v: 0,
      },
      {
        sender: "03-0000-00003",
        senderName: "Ranier Dave Arcega",
        receiver: "03-0000-00001",
        receiverName: "03-0000-00001",
        role: "Admin",
        title: "Schedule Duty",
        message:
          "You have a meeting scheduled with professor David Aldrin Mondero at 10 AM.",
        status: false,
        scheduleId: "",
        date: "2024-10-16",
        time: "15:19:27",
        createdAt: "2024-10-16T07:20:28.576+00:00",
        updatedAt: "2024-10-16T07:21:30.972+00:00",
        __v: 0,
      },
      {
        sender: "03-0000-00003",
        senderName: "Ranier Dave Arcega",
        receiver: "03-0000-00001",
        receiverName: "03-0000-00001",
        role: "Admin",
        title: "Schedule Duty",
        message:
          "Your presentation for professor David Aldrin Mondero's class is set for Thursday.",
        status: false,
        scheduleId: "",
        date: "2024-10-16",
        time: "15:19:27",
        createdAt: "2024-10-16T07:20:28.576+00:00",
        updatedAt: "2024-10-16T07:21:30.972+00:00",
        __v: 0,
      },
      {
        sender: "03-0000-00003",
        senderName: "Ranier Dave Arcega",
        receiver: "03-0000-00001",
        receiverName: "03-0000-00001",
        role: "Admin",
        title: "Schedule Duty",
        message:
          "You are required to submit your report to professor David Aldrin Mondero by Friday.",
        status: false,
        scheduleId: "",
        date: "2024-10-16",
        time: "15:19:27",
        createdAt: "2024-10-16T07:20:28.576+00:00",
        updatedAt: "2024-10-16T07:21:30.972+00:00",
        __v: 0,
      },
      {
        sender: "03-0000-00003",
        senderName: "Ranier Dave Arcega",
        receiver: "03-0000-00001",
        receiverName: "03-0000-00001",
        role: "Admin",
        title: "Schedule Duty",
        message:
          "You have a discussion scheduled with professor David Aldrin Mondero on Wednesday.",
        status: false,
        scheduleId: "",
        date: "2024-10-16",
        time: "15:19:27",
        createdAt: "2024-10-16T07:20:28.576+00:00",
        updatedAt: "2024-10-16T07:21:30.972+00:00",
        __v: 0,
      },
      
    ];

    // Insert the sample data
    await Notification.insertMany(notifications);

    console.log("Seed data inserted successfully");
  } catch (error) {
    console.error("Error seeding data:", error);
  } finally {
    // Close the connection
    mongoose.connection.close();
  }
};

// Run the seed function
seedNotifications();
