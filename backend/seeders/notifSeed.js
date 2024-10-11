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
        sender: "03-0000-00003", // Admin ID
        senderName: "Ranier Dave Arcega",
        receiver: "03-0000-00001",
        role: "Admin",
        title: "Account Verification",
        message: "Your account has been updated.",
        status: "unread",
        date: "2024-09-01",
        time: "08:30:00",
      },
      {
        sender: "03-0000-00003", // Admin ID
        senderName: "Ranier Dave Arcega",
        receiver: "03-0000-00001",
        role: "Admin",
        title: "Feature Update",
        message: "New feature released!",
        status: "unread",
        date: "2024-09-02",
        time: "10:15:00",
      },
      {
        sender: "03-0000-00002", // Student ID
        senderName: "Alice Johnson",
        receiver: "03-0000-00001",
        role: "Student",
        title: "Password Update",
        message: "Password change successful.",
        status: "unread",
        date: "2024-09-03",
        time: "14:45:00",
      },
      {
        sender: "03-0000-00004", // Student ID
        senderName: "Bob Brown",
        receiver: "03-0000-00001",
        role: "Student",
        title: "Account Suspension",
        message: "Account suspended due to suspicious activity.",
        status: "unread",
        date: "2024-09-01",
        time: "11:00:00",
      },
      {
        sender: "03-0000-00005", // Student ID
        senderName: "Charlie Davis",
        receiver: "03-0000-00001",
        role: "Student",
        title: "Welcome",
        message: "Welcome to our platform!",
        status: "read",
        date: "2024-09-04",
        time: "09:00:00",
      },
      {
        sender: "03-0000-00002", // Student ID
        senderName: "David Aldrin Mondero",
        receiver: "03-0000-00003",
        role: "Professor",
        title: "Need Faci",
        message:
          "I need faci for my schedule in flipino subject on every tuesday 1:30 to 3:00 pm",
        status: "read",
        date: "2024-09-04",
        time: "09:00:00",
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
