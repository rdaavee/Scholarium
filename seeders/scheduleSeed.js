const mongoose = require('mongoose');
const ClassSchedule = require('../models/schedule_model'); // Adjust the path as needed
require('dotenv').config();
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
        school_id: '03-0000-00001',
        room: 'Room 101',
        block: 'Block A',
        subject: 'Mathematics',
        prof_id: '03-0000-00002',
        professor: 'Dr. Alice Smith',
        department: 'CITE',
        time: '15:00:00',
        date: '2024-09-27',
        completed: false,
      },
      {
        school_id: '03-0000-00001',
        room: 'Room 102',
        block: 'Block B',
        subject: 'English',
        prof_id: '03-0000-00003',
        professor: 'Prof. Bob Johnson',
        department: 'CITE',
        time: '10:00:00',
        date: '2024-09-28',
        completed: 'pending',
      },
      {
        school_id: '03-0000-00001',
        room: 'Room 103',
        block: 'Block C',
        subject: 'Physics',
        prof_id: '03-0000-00004',
        professor: 'Dr. Carol Williams',
        department: 'CITE',
        time: '11:00:00',
        date: '2024-09-20',
        completed: 'pending',
      },
      {
        school_id: '03-0000-00001',
        room: 'Room 104',
        block: 'Block A',
        subject: 'Chemistry',
        prof_id: '03-0000-00005',
        professor: 'Prof. David Brown',
        department: 'CITE',
        time: '13:00:00',
        date: '2024-08-26',
        completed: false,
      },
      {
        school_id: '03-0000-00001',
        room: 'Room 105',
        block: 'Block B',
        subject: 'Biology',
        prof_id: '03-0000-00006',
        professor: 'Dr. Emma Jones',
        department: 'CITE',
        time: '14:00:00',
        date: '2024-08-26',
        completed: false,
      },
      {
        school_id: '03-0000-00006',
        room: 'Room 106',
        block: 'Block C',
        subject: 'History',
        prof_id: '03-0000-00007',
        professor: 'Prof. Frank Garcia',
        department: 'CITE',
        time: '15:00:00',
        date: '2024-08-26',
        completed: 'pending',
      },
      {
        school_id: '03-0000-00007',
        room: 'Room 107',
        block: 'Block A',
        subject: 'Geography',
        prof_id: '03-0000-00008',
        professor: 'Dr. Grace Martinez',
        department: 'CITE',
        time: '09:00:00',
        date: '2024-08-27',
        completed: 'pending',
      },
      {
        school_id: '03-0000-00008',
        room: 'Room 108',
        block: 'Block B',
        subject: 'Computer Science',
        prof_id: '03-0000-00009',
        professor: 'Prof. Henry Wilson',
        department: 'CITE',
        time: '10:00:00',
        date: '2024-08-27',
        completed: 'pending',
      },
      {
        school_id: '03-0000-00009',
        room: 'Room 109',
        block: 'Block C',
        subject: 'Art',
        prof_id: '03-0000-00010',
        professor: 'Dr. Irene Lee',
        department: 'CITE',
        time: '11:00:00',
        date: '2024-08-27',
        completed: 'pending',
      },
      {
        school_id: '03-0000-00010',
        room: 'Room 110',
        block: 'Block A',
        subject: 'Music',
        prof_id: '03-0000-00001',
        professor: 'Prof. Jack Anderson',
        department: 'CITE',
        time: '13:00:00',
        date: '2024-08-27',
        completed: 'pending',
      },
      {
        school_id: '03-0000-00002',
        room: 'Room 101',
        block: 'Block A',
        subject: 'Mathematics',
        prof_id: '03-0000-00002',
        professor: 'Dr. Alice Smith',
        department: 'CITE',
        time: '15:00:00',
        date: '2024-09-20',
        completed: false,
      },
      {
        school_id: '03-0000-00002',
        room: 'Room 102',
        block: 'Block B',
        subject: 'English',
        prof_id: '03-0000-00003',
        professor: 'Prof. Bob Johnson',
        department: 'CITE',
        time: '10:00:00',
        date: '2024-09-28',
        completed: 'pending',
      },
    ];

    // Insert the sample data
    await ClassSchedule.insertMany(schedules);

    console.log('Seed data inserted successfully');
  } catch (error) {
    console.error('Error seeding data:', error);
  } finally {
    // Close the connection
    mongoose.connection.close();
  }
};

// Run the seed function
seedClassSchedules();
