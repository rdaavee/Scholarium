const mongoose = require('mongoose');
const Post = require('../models/posts_model'); // Adjust the path as needed
require('dotenv').config();

const mongoURI = process.env.MONGODB_URI;

const seedPosts = async () => {
  try {
    // Connect to MongoDB
    await mongoose.connect(mongoURI);

    // Clear existing posts
    await Post.deleteMany({});

    // Define the professor_id and sample student school_ids
    const professor_id = '03-0000-00005'; // Single professor ID
    const studentSchoolIds = [
      '03-0000-00019',
      '03-0000-00001',
      '03-0000-00002',
      '03-0000-00003',
      '03-0000-00006'
    ];

    // Create sample posts
    const posts = studentSchoolIds.map((school_id, index) => ({
      title: `Sample Post ${index + 1}`,
      body: `This is the body of sample post ${index + 1}.`,
      status: 'Active',
      school_id: school_id,
      prof_id: professor_id, // Same professor for all posts
    }));

    // Insert the sample post data
    await Post.insertMany(posts);

    console.log('Posts seeded successfully');
  } catch (error) {
    console.error('Error seeding posts:', error);
  } finally {
    // Close the connection
    mongoose.connection.close();
  }
};

// Run the seed function
seedPosts();
