const mongoose = require('mongoose');
const HoursRendered = require('../models/dtr_model'); // Adjust the path as needed
require('dotenv').config();
const mongoURI = process.env.MONGODB_URI;

const seedHoursRendered = async () => {
  try {
    // Connect to MongoDB
    await mongoose.connect(mongoURI);

    // Clear existing hours rendered records
    await HoursRendered.deleteMany({});

    // Sample hours rendered data
    const hoursRenderedData = [
      {
        school_id: '03-0000-00001',
        date: '2024-08-26',
        time_in: '08:00:00',
        time_out: '16:00:00',
        hours_to_rendered: 8,
        hours_rendered: 7,
        professor: 'John Doe',
        professor_signature: 'Signature1',
      },
      {
        school_id: '03-0000-00002',
        date: '2024-08-27',
        time_in: '09:00:00',
        time_out: '17:00:00',
        hours_to_rendered: 8,
        hours_rendered: 6.5,
        professor: 'Jane Smith',
        professor_signature: 'Signature2',
      },
      {
        school_id: '03-0000-00003',
        date: '2024-08-28',
        time_in: '08:30:00',
        time_out: '15:30:00',
        hours_to_rendered: 8,
        hours_rendered: 6,
        professor: 'Michael Johnson',
        professor_signature: 'Signature3',
      },
      {
        school_id: '03-0000-00004',
        date: '2024-08-29',
        time_in: '07:45:00',
        time_out: '15:45:00',
        hours_to_rendered: 8,
        hours_rendered: 7.5,
        professor: 'Emily Williams',
        professor_signature: 'Signature4',
      },
      {
        school_id: '03-0000-00005',
        date: '2024-08-30',
        time_in: '08:00:00',
        time_out: '16:00:00',
        hours_to_rendered: 8,
        hours_rendered: 6.5,
        professor: 'David Brown',
        professor_signature: 'Signature5',
      },
      {
        school_id: '03-0000-00006',
        date: '2024-08-31',
        time_in: '09:00:00',
        time_out: '17:00:00',
        hours_to_rendered: 8,
        hours_rendered: 7,
        professor: 'Sarah Jones',
        professor_signature: 'Signature6',
      },
      {
        school_id: '03-0000-00007',
        date: '2024-09-01',
        time_in: '08:15:00',
        time_out: '16:15:00',
        hours_to_rendered: 8,
        hours_rendered: 7.5,
        professor: 'Robert Garcia',
        professor_signature: 'Signature7',
      },
      {
        school_id: '03-0000-00008',
        date: '2024-09-02',
        time_in: '08:30:00',
        time_out: '15:30:00',
        hours_to_rendered: 8,
        hours_rendered: 6,
        professor: 'Jessica Martinez',
        professor_signature: 'Signature8',
      },
      {
        school_id: '03-0000-00009',
        date: '2024-09-03',
        time_in: '08:00:00',
        time_out: '16:00:00',
        hours_to_rendered: 8,
        hours_rendered: 6.5,
        professor: 'James Miller',
        professor_signature: 'Signature9',
      },
      {
        school_id: '03-0000-00001',
        date: '2024-09-04',
        time_in: '09:00:00',
        time_out: '17:00:00',
        hours_to_rendered: 8,
        hours_rendered: 7,
        professor: 'Linda Davis',
        professor_signature: 'Signature10',
      },
    ];

    // Insert the sample data
    await HoursRendered.insertMany(hoursRenderedData);

    console.log('Seed data inserted successfully');
  } catch (error) {
    console.error('Error seeding data:', error);
  } finally {
    // Close the connection
    mongoose.connection.close();
  }
};

// Run the seed function
seedHoursRendered();
