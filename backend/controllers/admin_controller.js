const mongoose = require("mongoose");
const moment = require("moment");
const User = require("../models/user_model");
const Schedule = require("../models/schedule_model");
const Announcement = require("../models/announcement_model");
const Notifications = require("../models/notifications_model");

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

exports.createScheduleAndNotification = async (req, res) => {
  try {
    const { schedule, notification } = req.body;
    console.log(req.body);

    const newSchedule = new Schedule({
      school_id: schedule.school_id,
      room: schedule.room,
      block: schedule.block,
      subject: schedule.subject,
      prof_id: schedule.prof_id,
      professor: schedule.professor,
      department: schedule.department,
      time: schedule.time,
      date: schedule.date,
      isActive: schedule.isActive,
      isCompleted: schedule.isCompleted || "pending",
    });

    const savedSchedule = await newSchedule.save();

    const newNotification = new Notifications({
      sender: notification.sender,
      senderName: notification.senderName,
      receiver: savedSchedule.school_id,
      receiverName: notification.receiverName,
      role: notification.role,
      title: notification.title,
      message: notification.message,
      scheduleId: savedSchedule._id,
      date: currentDate,
      time: currentTime,
      status: notification.status,
      profile_picture: notification.profile_picture,
    });

    await newNotification.save();

    res.status(200).json({
      message: `Notification "${notification.title}" has been sent by ${
        notification.senderName
      } to ${notification.receiverName || "all"}.`,
      schedule: savedSchedule,
      notification: newNotification,
    });
    console.log(savedSchedule, newNotification);
  } catch (error) {
    console.error("Error creating schedule or notification:", error);
    res.status(500).json({ message: error.message });
  }
};

// Delete a schedule
exports.deleteScheduleAndNotification = async (req, res) => {
  const { scheduleId, school_id } = req.body;
  console.log(req.body);
  try {
    let result;
    const schedule = await Schedule.findOne({ _id: scheduleId});
    console.log(schedule);
    const admin = await User.findOne({ school_id: school_id });
    const bot = await User.findOne({ school_id: "00-0000-00000" });
    
    const user = await User.findOne({ school_id: schedule.school_id });
    const prof = await User.findOne({ school_id: schedule.prof_id });
    if (scheduleId == null || scheduleId == "") {
      const profNotification = new Notifications({
        sender: bot.school_id,
        senderName: bot.first_name + " " + bot.last_name,
        receiver: prof.school_id,
        receiverName: `${prof.first_name} ${prof.last_name}`,
        role: "Bot",
        title: "Task Alert",
        message: `Dear Professor ${prof.first_name} ${prof.last_name}, the task assigned to ${user.first_name} ${user.last_name} has been rejected. Please review the task details and take appropriate action.`,
        scheduleId: "",
        date: currentDate,
        time: currentTime,
        status: false,
        profile_picture: bot.profile_picture,
      });

      await profNotification.save();
      console.log(profNotification);

      const adminNotification = new Notifications({
        sender: bot.school_id,
        senderName: bot.first_name + " " + bot.last_name,
        receiver: admin.school_id,
        receiverName: `${admin.first_name} ${admin.last_name}`,
        role: "Bot",
        title: "Task Alert",
        message: `Dear Admin ${admin.first_name} ${admin.last_name}, the task assigned to ${user.first_name} ${user.last_name} has been rejected.`,
        scheduleId: "",
        date: currentDate,
        time: currentTime,
        status: false,
        profile_picture: bot.profile_picture,
      });

      await adminNotification.save();
      console.log(adminNotification);
    } else {
      result = await Schedule.deleteOne({ _id: scheduleId });
      const profNotification = new Notifications({
        sender: bot.school_id,
        senderName: bot.first_name + " " + bot.last_name,
        receiver: prof.school_id,
        receiverName: `${prof.first_name} ${prof.last_name}`,
        role: "Bot",
        title: "Task Alert",
        message: `Dear Professor ${prof.first_name} ${prof.last_name}, the task assigned to ${user.first_name} ${user.last_name} has been rejected. Please review the task details and take appropriate action.`,
        scheduleId: "",
        date: currentDate,
        time: currentTime,
        status: false,
        profile_picture: bot.profile_picture,
      });

      await profNotification.save();
      console.log(profNotification);

      const adminNotification = new Notifications({
        sender: bot.school_id,
        senderName: bot.first_name + " " + bot.last_name,
        receiver: admin.school_id,
        receiverName: `${admin.first_name} ${admin.last_name}`,
        role: "Bot",
        title: "Task Alert",
        message: `Dear Admin ${admin.first_name} ${admin.last_name}, the task assigned to ${user.first_name} ${user.last_name} has been rejected.`,
        scheduleId: "",
        date: currentDate,
        time: currentTime,
        status: false,
        profile_picture: bot.profile_picture,
      });

      await adminNotification.save();
      console.log(adminNotification);
    }

    if (scheduleId && result && result.deletedCount > 0) {
      // Only check result if schedule deletion occurs
      console.log(`Deleted this record ${result}`);
      res.status(200).json({
        message: `Record with schedule ID #${scheduleId} has been deleted.`,
      });
    } else {
      res.status(404).json({ message: "User not found" });
    }
  } catch (error) {
    console.error("Error deleting user:", error);
    res.status(500).json({ message: "Server error occurred" });
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

exports.createNotification = async (req, res) => {
  try {
    const {
      sender,
      senderName,
      receiver,
      receiverName,
      role,
      title,
      message,
      scheduleId,
      isActive,
    } = req.body;

    const notification = new Notifications({
      sender: sender,
      senderName: senderName,
      receiver,
      receiverName,
      role,
      title,
      message,
      scheduleId,
      date: currentDate,
      time: currentTime,
      isActive: isActive,
    });

    await notification.save();

    res.status(200).json({
      message: `Notification "${notification.title}" has been sent by ${
        notification.senderName
      } to ${notification.receiverName || "all"}.`,
    });
  } catch (error) {
    console.error("Error creating notification:", error);
    res.status(500).json({ message: error.message });
  }
};

//-------------------------------------------- ANNOUNCEMENT CRUD ----------------------------------------------------------------------

const currentDate = moment().format("YYYY-MM-DD");
const currentTime = moment().format("HH:mm:ss");

// Get all Announcements
exports.getAllAnnouncements = async (req, res) => {
  try {
    const announcement = await Announcement.find().sort({ date: -1 });
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
    res.status(200).json({
      message: `Announcement with ID ${req.userSchoolId} has been updated.`,
    });
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
      res
        .status(200)
        .json({ message: `Announcement with ID #${id} has been deleted.` });
    } else {
      res.status(404).json({ message: "Announcement doesn't exist" });
    }
  } catch (error) {
    console.error("Error deleting announcement:", error);
    res.status(500).json({ message: "Server error occurred" });
  }
};
