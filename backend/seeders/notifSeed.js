const mongoose = require('mongoose');
const Notification = require('../models/notifications_model'); // Adjust the path as needed
require('dotenv').config();
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
        school_id: '03-0000-00001',
        sender: 'John Doe',
        role: 'Student',
        message: 'Your account has been updated.',
        status: 'unread',
        date: '2024-09-01',
        time: '08:30:00',
      },
      {
        school_id: '03-0000-00001',
        sender: 'Jane Smith',
        role: 'Student',
        message: 'New feature released!',
        status: 'read',
        date: '2024-09-02',
        time: '10:15:00',
      },
      {
        school_id: '03-0000-00001',
        sender: 'Alice Johnson',
        role: 'Student',
        message: 'Password change successful.',
        status: 'unread',
        date: '2024-09-03',
        time: '14:45:00',
      },
      {
        school_id: '03-0000-00001',
        sender: 'Bob Brown',
        role: 'Student',
        message: 'Account suspended due to suspicious activity.',
        status: 'unread',
        date: '2024-09-01',
        time: '11:00:00',
      },
      {
        school_id: '03-0000-00001',
        sender: 'Charlie Davis',
        role: 'Student',
        message: 'Welcome to our platform!',
        status: 'read',
        date: '2024-09-04',
        time: '09:00:00',
      },
      {
        school_id: '03-0000-00001',
        sender: 'Diana Evans',
        role: 'Student',
        message: 'Your post has been approved.',
        status: 'read',
        date: '2024-09-05',
        time: '13:20:00',
      },
      {
        school_id: '03-0000-00001',
        sender: 'Edward Green',
        role: 'Student',
        message: 'System maintenance scheduled.',
        status: 'unread',
        date: '2024-09-06',
        time: '16:30:00',
      },
      {
        school_id: '03-0000-00001',
        sender: 'Fiona Harris',
        role: 'Teacher',
        message: 'New friend request received.',
        status: 'read',
        date: '2024-09-07',
        time: '18:45:00',
      },
      {
        school_id: '03-0000-00001',
        sender: 'George King',
        role: 'Professor',
        message: 'Your comment has been flagged.',
        status: 'unread',
        date: '2024-09-08',
        time: '20:00:00',
      },
      {
        school_id: '03-0000-00001',
        sender: 'Hannah Lee',
        role: 'Student',
        message: 'Profile picture updated successfully.',
        status: 'read',
        date: '2024-09-09',
        time: '12:30:00',
      },
    ];

    // Insert the sample data
    await Notification.insertMany(notifications);

    console.log('Seed data inserted successfully');
  } catch (error) {
    console.error('Error seeding data:', error);
  } finally {
    // Close the connection
    mongoose.connection.close();
  }
};

// Run the seed function
seedNotifications();
