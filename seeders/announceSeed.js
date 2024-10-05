const mongoose = require('mongoose');
const Announcement = require('../models/announcement_model'); // Adjust the path as needed
require('dotenv').config();
const mongoURI = process.env.MONGODB_URI;

const seedAnnouncements = async () => {
  try {
    // Connect to MongoDB
    await mongoose.connect(mongoURI);

    // Clear existing announcements
    await Announcement.deleteMany({});

    // Sample announcement data
    const announcementData = [
      {
        admin_id: '03-0000-00001',
        title: 'Meeting with Staff',
        body: 'Discuss the new curriculum changes.',
        time: '10:00:00',
        date: '2024-08-26',
      },
      {
        admin_id: '03-0000-00002',
        title: 'Faculty Workshop',
        body: 'Workshop on advanced teaching techniques.',
        time: '11:30:00',
        date: '2024-08-27',
      },
      {
        admin_id: '03-0000-00003',
        title: 'Parent-Teacher Conference',
        body: 'Annual conference with parents.',
        time: '14:00:00',
        date: '2024-07-28',
      },
    ];

    // Insert the sample data
    await Announcement.insertMany(announcementData);

    console.log('Seed data inserted successfully');
  } catch (error) {
    console.error('Error seeding data:', error);
  } finally {
    // Close the connection
    mongoose.connection.close();
  }
};

// Run the seed function
seedAnnouncements();
