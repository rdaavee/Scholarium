const moment = require("moment");
const User = require('../models/user_model'); 
const Announcement = require('../models/announcement_model');
const Post = require('../models/posts_model');
const Schedule = require('../models/schedule_model'); 
const DTR = require('../models/dtr_model'); 
const Notification = require('../models/notifications_model');

// Middleware to validate token and extract user ID
const validateToken = async (req, res, next) => {
  // Implement your token validation logic here to set req.userId
};

// Get Announcement
exports.getAnnouncements = async (req, res) => {
  try {
    const announcements = await Announcement.find();
    res.status(200).json(announcements);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

// Get Latest Announcement
exports.getLatestAnnouncement = async (req, res) => {
  try {
    const latestAnnouncement = await Announcement.find().sort({ date: -1 }).limit(1);
    
    if (latestAnnouncement.length > 0) {
      const announcementDate = moment(latestAnnouncement[0].date);
      const currentDate = moment().format("YYYY-MM-DD");

      if (announcementDate.isSame(currentDate)) {
        res.status(200).json(latestAnnouncement[0]);
      } else {
        res.status(204).json({ message: "No data today" });
      }
    } else {
      res.status(404).json({ message: "No announcements found" });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

// Get Posts
exports.getPosts = async (req, res) => {
  try {
    const posts = await Post.find({ status: req.params.status });
    res.status(200).json(posts);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

// Get User Upcoming Schedule
exports.getUserUpcomingSchedule = async (req, res) => {
  try {
    const user = await User.findById(req.userId); // Get user ID from middleware
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const school_id = user.school_id;
    const currentDate = moment().format("YYYY-MM-DD");
    const schedules = await Schedule.find({
      school_id: school_id,
      $or: [{ date: currentDate }, { date: { $gt: currentDate } }]
    }).sort({ date: 1 });

    if (schedules.length > 0) {
      const todaySchedule = schedules.filter(schedule => moment(schedule.date).isSame(currentDate, "day"));
      const nextSchedule = schedules.find(schedule => moment(schedule.date).isAfter(currentDate));

      res.status(200).json({
        today: todaySchedule.length ? todaySchedule : null,
        next: nextSchedule || null,
      });
    } else {
      res.status(404).json({ message: "No schedule found" });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error occurred" });
  }
};

// Get User DTR
exports.getUserDTR = async (req, res) => {
  try {
    const user = await User.findById(req.userId); // Get user ID from middleware
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const dtrRecords = await DTR.find({ school_id: user.school_id });
    if (dtrRecords.length > 0) {
      res.status(200).json(dtrRecords);
    } else {
      res.status(404).json({ message: "User DTR not found" });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error occurred" });
  }
};

// Get User Total Hours
exports.getUserTotalHours = async (req, res) => {
  try {
    const user = await User.findById(req.userId); // Get user ID from middleware
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const result = await DTR.aggregate([
      { $match: { school_id: user.school_id } },
      { $group: { _id: null, total_hours: { $sum: "$hours_rendered" }, target_hours: { $first: "$hours_to_rendered" } } }
    ]);

    if (result.length > 0) {
      res.status(200).json({
        totalhours: result[0].total_hours,
        targethours: result[0].target_hours,
      });
    } else {
      res.status(404).json({ message: "No hours rendered found for this user" });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error occurred" });
  }
};

// Get User Schedule
exports.getUserSchedule = async (req, res) => {
  const month = req.params.month; // Expecting a month in 'YYYY-MM' format

  try {
    const user = await User.findById(req.userId); // Get user ID from middleware
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const school_id = user.school_id;

    // Update schedules with past dates to set completed to false
    await updatePastSchedules(school_id);

    // Construct the date range as strings
    const startOfMonth = moment(month).startOf('month').format('YYYY-MM-DD');
    const endOfMonth = moment(month).endOf('month').format('YYYY-MM-DD');

    // Fetch the schedules based on the school_id and the date range
    const schedules = await Schedule.find({
      school_id: school_id,
      date: { $gte: startOfMonth, $lte: endOfMonth }
    }).sort({ date: 1 });

    // Mark past schedules as false if not already true
    const currentDate = moment().startOf('day');
    const updatePromises = schedules.map(schedule => {
      const scheduleDate = moment(schedule.date);

      // Mark as false if the date is in the past and completed is not "true"
      if (scheduleDate.isBefore(currentDate) && schedule.completed !== "true") {
        return Schedule.updateOne({ _id: schedule._id }, { completed: 'false' });
      }
    });

    // Execute all update promises
    await Promise.all(updatePromises);

    if (schedules.length > 0) {
      res.status(200).json(schedules);
    } else {
      res.status(404).json({ message: "No schedules found for this month" });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error occurred" });
  }
};

// Helper function to update past schedules
async function updatePastSchedules(school_id) {
  const currentDate = moment().startOf('day');
  const pastSchedules = await Schedule.find({
    school_id: school_id,
    date: { $lt: currentDate.format('YYYY-MM-DD') } // Fetch past schedules
  });

  const updatePromises = pastSchedules.map(schedule => {
    if (schedule.completed !== "true") {
      return Schedule.updateOne({ _id: schedule._id }, { completed: 'false' });
    }
  });

  await Promise.all(updatePromises);
}

exports.getUserNotifications = async (req, res) => {
  try {
    const user = await User.findById(req.userId);
    console.log("User ID:", req.userId);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const notifications = await Notification.find({ school_id: user.school_id });
    if (notifications.length > 0) {
      res.status(200).json(notifications);
    } else {
      res.status(404).json({ message: "No notifications found" });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error occurred" });
  }
};

// Update Notification Status to Read or Unread
exports.updateNotificationStatus = async (req, res) => {
  const notificationId = req.params.id;
  try {
    const result = await Notification.updateOne({ _id: notificationId }, { status: "read" });
    if (result.nModified > 0) {
      res.status(200).json({ message: "Notification status updated to read" });
    } else {
      res.status(404).json({ message: "Notification not found" });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error occurred" });
  }
};

// Get specific user
exports.getUserProfile = async (req, res) => {
  try {
    const user = await User.findById(req.userId);
    if (user) {
      const baseUrl = "http://192.168.42.137:3000"; 
      res.status(200).json({
        id: user._id,
        school_id: user.school_id,
        email: user.email,
        first_name: user.first_name,
        middle_name: user.middle_name,
        last_name: user.last_name,
        profile_picture: user.profile_picture
          ? `${baseUrl}/uploads/profile_pictures/${user.profile_picture}`
          : null,
        gender: user.gender,
        contact: user.contact,
        address: user.address,
        role: user.role,
        hk_type: user.hk_type,
        status: user.status,
        token: user.token,
      });
    } else {
      res.status(404).json({ message: "User not found" });
    }
  } catch (error) {
    console.error("Error in getUserProfile:", error);
    res.status(500).json({ message: "Server error occurred" });
  }
};

// Change Password
exports.updatePassword = async (req, res) => {
  const { oldPassword, newPassword } = req.body; 

  try {
    const user = await User.findById(req.userId);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    if (user.password !== oldPassword) {
      return res.status(400).json({ message: "Old password is incorrect" });
    }
    user.password = newPassword; 
    await user.save();

    res.status(200).json({ message: "Password updated successfully", success: true });
  } catch (error) {
    console.error("Error in updatePassword:", error);
    res.status(500).json({ message: "Server error occurred" });
  }
};

