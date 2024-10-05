const mongoose = require('mongoose');
const User = require('../models/user_model'); // Adjust the path as needed
require('dotenv').config();
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
        school_id: '03-0000-00001',
        email: 'benedict@phinmaed.com',
        password: '1',
        first_name: 'Mark Benedict',
        middle_name: 'C.',
        last_name: 'Abalos',
        profile_picture: null,
        gender: 'Male',
        contact: '09516185235',
        address: 'Baybay Polong',
        role: 'Student',
        hk_type: 'HK 25',
        status: 'Active',
        token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MzQsI...',
        professor: '03-0000-00002', // Add professor field here
      },
      {
        school_id: '03-0000-00002',
        email: 'david@phinmaed.com',
        password: '2',
        first_name: 'David Aldrin',
        middle_name: 'F.',
        last_name: 'Mondero',
        profile_picture: null,
        gender: 'Male',
        contact: '0900-000-0002',
        address: '456 Oak St',
        role: 'Professor',
        hk_type: '',
        status: 'Active',
        token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MzUsI...',
      },
      {
        school_id: '03-0000-00003',
        email: 'ranier@phinmaed.com',
        password: '3',
        first_name: 'Ranier Dave',
        middle_name: 'T.',
        last_name: 'Arcega',
        profile_picture: null,
        gender: 'Male',
        contact: '0900-000-0003',
        address: '789 Pine St',
        role: 'Admin',
        hk_type: '',
        status: 'Active',
        token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MzYsI...',
      },
      {
        school_id: '03-0000-00004',
        email: 'dummy4@phinmaed.com',
        password: '4',
        first_name: 'Emily',
        middle_name: 'D.',
        last_name: 'Williams',
        profile_picture: null,
        gender: 'Female',
        contact: '0900-000-0004',
        address: '101 Elm St',
        role: 'Student',
        hk_type: 'HK 50',
        status: 'Active',
        token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MzcsI...',
        professor: '03-0000-00002', // Add professor field here
      },
      {
        school_id: '03-0000-00005',
        email: 'dummy5@phinmaed.com',
        password: '5',
        first_name: 'David',
        middle_name: 'E.',
        last_name: 'Brown',
        profile_picture: null,
        gender: 'Male',
        contact: '0900-000-0005',
        address: '202 Maple St',
        role: 'Professor',
        hk_type: 'HK 75',
        status: 'Inactive',
        token: null,
      },
      {
        school_id: '03-0000-00006',
        email: 'dummy6@phinmaed.com',
        password: '6',
        first_name: 'Sarah',
        middle_name: 'F.',
        last_name: 'Jones',
        profile_picture: null,
        gender: 'Female',
        contact: '0900-000-0006',
        address: '303 Cedar St',
        role: 'Student',
        hk_type: 'HK 25',
        status: 'Active',
        token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MzksI...',
        professor: '03-0000-00002', // Add professor field here
      },
      {
        school_id: '03-0000-00007',
        email: 'dummy7@phinmaed.com',
        password: '7',
        first_name: 'Robert',
        middle_name: 'G.',
        last_name: 'Garcia',
        profile_picture: null,
        gender: 'Male',
        contact: '0900-000-0007',
        address: '404 Birch St',
        role: 'Admin',
        hk_type: 'HK 50',
        status: 'Active',
        token: null,
      },
      {
        school_id: '03-0000-00008',
        email: 'dummy8@phinmaed.com',
        password: '8',
        first_name: 'Jessica',
        middle_name: 'H.',
        last_name: 'Martinez',
        profile_picture: null,
        gender: 'Female',
        contact: '0900-000-0008',
        address: '505 Walnut St',
        role: 'Professor',
        hk_type: 'HK 75',
        status: 'Inactive',
        token: null,
      },
      {
        school_id: '03-0000-00009',
        email: 'dummy9@phinmaed.com',
        password: '9',
        first_name: 'James',
        middle_name: 'I.',
        last_name: 'Miller',
        profile_picture: '1724830416367.png',
        gender: 'Male',
        contact: '0900-000-0009',
        address: '606 Willow St',
        role: 'Student',
        hk_type: 'HK 25',
        status: 'Active',
        token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NDIsI...',
        professor: '03-0000-00002', // Add professor field here
      },
      {
        school_id: '03-0000-00010',
        email: 'dummy10@phinmaed.com',
        password: '10',
        first_name: 'Linda',
        middle_name: 'J.',
        last_name: 'Davis',
        profile_picture: null,
        gender: 'Female',
        contact: '0900-000-0010',
        address: '707 Poplar St',
        role: 'Admin',
        hk_type: 'HK 50',
        status: 'Inactive',
        token: 'eyJhbGciOiJIUzI1NiIsInR...',
      },
    ];

    // Insert the sample data
    await User.insertMany(users);

    console.log('Seed data inserted successfully');
  } catch (error) {
    console.error('Error seeding data:', error);
  } finally {
    // Close the connection
    mongoose.connection.close();
  }
};

// Run the seed function
seedUsers();
