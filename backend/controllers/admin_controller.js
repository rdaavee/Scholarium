const mongoose = require("mongoose");
const moment = require("moment");
const User = require("../models/user_model");
const Schedule = require("../models/schedule_model");
const Announcement = require("../models/announcement_model");

//-------------------------------------------- STUDENT CRUD ----------------------------------------------------------------------
// Get all users
exports.getAllUsers = async (req, res) => {
  try {
    const users = await User.find();
    res.status(200).json(users);
  } catch (error) {
    console.error("Error fetching users:", error);
    res.status(500).json({ message: "Error fetching users" });
  }
};

// Create a user
exports.createUser = async (req, res) => {
  try {
    const params = req.body;

    const user = new User({
      school_id: params.school_id,
      email: params.email,
      password: params.password,
      first_name: params.first_name,
      middle_name: params.middle_name,
      last_name: params.last_name,
      profile_picture: params.profile_picture,
      gender: params.gender,
      contact: params.contact,
      address: params.address,
      role: params.role,
      professor: params.professor,
      hk_type: params.hk_type,
      status: params.status,
      token: params.token,
    });

    await user.save();
    res.status(200).json({
      message: `Record of ${user.last_name}, ${user.first_name} has been added.`,
    });
  } catch (error) {
    console.error("Error creating user:", error);
    res.status(500).json({ message: error.message });
  }
};

exports.getCurrentYearSchedules = async (req, res) => {
  try {
    const currentYear = moment().year().toString();
    const schedules = await Schedule.find({
      date: { $regex: `^${currentYear}` },
    });

    res.status(200).json(schedules);
  } catch (error) {
    console.error("Error fetching schedules:", error);
    res.status(500).json({ message: "Error fetching schedules" });
  }
};

// Update user
exports.updateUser = async (req, res) => {
  const school_id = req.params.school_id;
  const params = req.body;

  try {
    const user = await User.findOneAndUpdate(
      { school_id: school_id },
      {
        email: params.email,
        password: params.password,
        first_name: params.first_name,
        middle_name: params.middle_name,
        last_name: params.last_name,
        profile_picture: params.profile_picture,
        gender: params.gender,
        contact: params.contact,
        address: params.address,
        role: params.role,
        hk_type: params.hk_type,
        status: params.status,
        token: params.token,
      },
      { new: true }
    );

    if (!user) {
      return res
        .status(404)
        .json({ message: `No record found with school ID ${school_id}.` });
    }
    res.status(200).json({
      message: `Record of ${user.last_name}, ${user.first_name} has been updated.`,
    });
  } catch (error) {
    console.error("Error updating user:", error);
    res.status(500).json({ message: "Database query error" });
  }
};

// Delete a user
exports.deleteUser = async (req, res) => {
  const school_id = req.params.school_id;

  try {
    const result = await User.deleteOne({ school_id: school_id });

    if (result.deletedCount > 0) {
      res.status(200).json({
        message: `Record with school ID #${school_id} has been deleted.`,
      });
    } else {
      res.status(404).json({ message: "User not found" });
    }
  } catch (error) {
    console.error("Error deleting user:", error);
    res.status(500).json({ message: "Server error occurred" });
  }
};

//-------------------------------------------- ANNOUNCEMENT CRUD ----------------------------------------------------------------------

const currentDate = moment().format("YYYY-MM-DD");
const currentTime = moment().format("HH:mm:ss");

// Get all Announcements
exports.getAllAnnouncements = async (req, res) => {
  try {
    const announcement = await Announcement.find();
    res.status(200).json(announcement);
  } catch (error) {
    console.error("Error fetching announcement:", error);
    res.status(500).json({ message: "Error fetching announcement" });
  }
};

// Create announcement with extracted school_id
exports.createAnnouncement = async (req, res) => {
  try {
    const params = req.body;

    const announcement = new Announcement({
      admin_id: req.userSchoolId,
      title: params.title,
      body: params.body,
      time: currentTime,
      date: currentDate,
    });

    await announcement.save();
    res.status(200).json({
      message: `Announcement "${announcement.title}" has been added by user with school ID ${req.userSchoolId}.`,
    });
  } catch (error) {
    console.error("Error creating announcement:", error);
    res.status(500).json({ message: error.message });
  }
};

// Update announcement
exports.updateAnnouncement = async (req, res) => {
  try {
    const params = req.body;
    const announcement = await Announcement.findByIdAndUpdate(
      req.userSchoolId,
      {
        title: params.title,
        body: params.body,
        time: currentTime,
        date: currentDate,
      },
      { new: true }
    );

    if (!announcement) {
      return res
        .status(404)
        .json({ message: `No record found with ID ${req.userSchoolId}.` });
    }
    res
      .status(200)
      .json({ message: `Announcement with ID ${req.userSchoolId} has been updated.` });
  } catch (error) {
    console.error("Error updating announcement:", error);
    res.status(500).json({ message: error.message });
  }
};

// Delete announcement
exports.deleteAnnouncement = async (req, res) => {
  const id = req.params.id;

  try {
      const result = await Announcement.deleteOne({ _id: id });

      if (result.deletedCount > 0) {
          res.status(200).json({ message: `Announcement with ID #${id} has been deleted.` });
      } else {
          res.status(404).json({ message: "Announcement doesn't exist" });
      }
  } catch (error) {
      console.error('Error deleting announcement:', error);
      res.status(500).json({ message: 'Server error occurred' });
  }
};