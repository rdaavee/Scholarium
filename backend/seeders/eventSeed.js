const mongoose = require('mongoose');
const Events = require('../models/events_model'); // Adjust the path as needed
require('dotenv').config();
const mongoURI = process.env.MONGODB_URI;

const seedEvents = async () => {
  try {
    // Connect to MongoDB
    await mongoose.connect(mongoURI);

    // Clear existing events
    await Events.deleteMany({}); // Adjust criteria if needed

    // Sample event data
    const events = [
      {
        name_of_event: 'Science Fair',
        images: 'image1.jpg',
        description: 'An exciting science fair showcasing student projects.',
        date: '2024-09-30',
        time: '09:00 - 16:00',
      },
      {
        name_of_event: 'Annual Sports Day',
        images: 'image2.jpg',
        description: 'A day filled with sports and fun activities for students.',
        date: '2024-10-15',
        time: '08:00 - 17:00',
      },
      {
        name_of_event: 'Art Exhibition',
        images: 'image3.jpg',
        description: 'An exhibition featuring artworks created by students.',
        date: '2024-11-05',
        time: '10:00 - 18:00',
      },
    ];

    // Insert the sample data
    await Events.insertMany(events);

    console.log('Seed data inserted successfully');
  } catch (error) {
    console.error('Error seeding data:', error);
  } finally {
    // Close the connection
    mongoose.connection.close();
  }
};

// Run the seed function
seedEvents();
