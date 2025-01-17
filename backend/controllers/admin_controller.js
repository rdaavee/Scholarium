const mongoose = require("mongoose");
const moment = require("moment");
const User = require("../models/user_model");
const Schedule = require("../models/schedule_model");
const DTR = require("../models/dtr_model");
const Announcement = require("../models/announcement_model");
const Notifications = require("../models/notifications_model");
const currentDate = moment().format("YYYY-MM-DD");
const currentTime = moment().format("HH:mm:ss");
const connectedUsers = require("../sockets/connected_users");

//--------------------------------------------SEND NOTIFICATION FUNCTION-------------------------------------------------------
function sendNotification(io, schoolId, notification) {
  if (connectedUsers[schoolId]) {
    io.of("/notifications")
      .to(connectedUsers[schoolId])
      .emit("receiveNotification", notification);
    console.log(`Notify success for ${schoolId}`);
  } else {
    console.error(
      `Failed to send notification: Receiver ${schoolId} is not connected.`
    );
  }
}

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

exports.getAllDTR = async (req, res) => {
  try {
    const result = await DTR.aggregate([
      // Group by school_id and calculate the sum of hours_rendered and hours_to_rendered
      {
        $group: {
          _id: "$school_id",
          totalHoursRendered: { $sum: "$hours_rendered" },
          totalHoursToRendered: { $first: "$hours_to_rendered" },
        },
      },
      // Add a field to check if totalHoursRendered > totalHoursToRendered
      {
        $addFields: {
          exceededHours: {
            $gt: ["$totalHoursRendered", "$totalHoursToRendered"],
          },
        },
      },
      // Count only the entries where exceededHours is true
      {
        $group: {
          _id: null,
          count: { $sum: { $cond: ["$exceededHours", 1, 0] } },
        },
      },
    ]);

    // If no records are found
    const exceededCount = result.length > 0 ? result[0].count : 0;

    res.status(200).json({
      message: "DTRs processed successfully",
      exceededCount: exceededCount,
    });
  } catch (error) {
    console.error("Error fetching DTRs:", error);
    res.status(500).json({ message: "Error fetching DTRs" });
  }
};

exports.countCompletedSchedulesByDayThisWeek = async (req, res) => {
  try {
    // Get the start and end dates of the current week (Monday to Saturday)
    const startOfWeek = moment().startOf("isoWeek").toDate(); // Monday
    const endOfWeek = moment().endOf("isoWeek").subtract(1, "days").toDate(); // Saturday

    // Aggregate the schedules for the current week
    const result = await Schedule.aggregate([
      {
        // Match schedules that are completed and fall within the current week's createdAt range
        $match: {
          completed: "true",
          createdAt: { $gte: startOfWeek, $lte: endOfWeek }, // Filter for the current week based on createdAt
        },
      },
      {
        // Add a new field to extract the day of the week from createdAt
        $addFields: {
          dayOfWeek: {
            $dayOfWeek: "$createdAt", // Extract day of the week directly from createdAt
          },
        },
      },
      {
        // Group by day of the week and school_id to ensure no repeat users for a particular day
        $group: {
          _id: { dayOfWeek: "$dayOfWeek", school_id: "$school_id" },
        },
      },
      {
        // Group again by dayOfWeek to count distinct users per day
        $group: {
          _id: "$_id.dayOfWeek",
          userCount: { $sum: 1 },
        },
      },
      {
        // Only include results for Monday to Saturday
        $match: {
          _id: { $gte: 2, $lte: 7 }, // 2 is Monday, 7 is Saturday in MongoDB's $dayOfWeek
        },
      },
      {
        // Project the day of the week as a string
        $project: {
          day: {
            $switch: {
              branches: [
                { case: { $eq: [2, "$_id"] }, then: "Monday" },
                { case: { $eq: [3, "$_id"] }, then: "Tuesday" },
                { case: { $eq: [4, "$_id"] }, then: "Wednesday" },
                { case: { $eq: [5, "$_id"] }, then: "Thursday" },
                { case: { $eq: [6, "$_id"] }, then: "Friday" },
                { case: { $eq: [7, "$_id"] }, then: "Saturday" },
              ],
              default: "Unknown",
            },
          },
          userCount: 1,
        },
      },
      {
        // Sort the results by day of the week
        $sort: { _id: 1 },
      },
    ]);

    console.log(result); // { day: 'Monday', userCount: 10 }, etc.
    res.status(200).json(result);
  } catch (error) {
    console.error("Error fetching schedule counts by day:", error);
    throw new Error("Error fetching schedule counts by day");
  }
};

// Create a user
exports.createUser = async (req, res) => {
  const params = req.body;

  try {
    const existingUser = await User.findOne({ school_id: params.school_id });
    if (existingUser) {
      return res.status(400).json({
        error: true,
        message: "User with this school ID already exists.",
      });
    }

    let professorName = "";
    let professorId = "";
    if (params.prof_id) {
      const prof = await User.findOne({ school_id: params.prof_id });
      if (prof) {
        professorName = `${prof.first_name ?? ""} ${
          prof.last_name ?? ""
        }`.trim();
        professorId = params.prof_id;
      }
    }

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
      professor: professorName,
      prof_id: professorId,
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
    res.status(500).json({ error: true, message: error.message });
  }
};

exports.getScheduleAdmin = async (req, res) => {
  const { month } = req.params;
  console.log(month);
  try {
    const startOfMonth = moment(month).startOf("month").format("YYYY-MM-DD");
    const endOfMonth = moment(month).endOf("month").format("YYYY-MM-DD");
    const schedules = await Schedule.find({
      date: { $gte: startOfMonth, $lte: endOfMonth },
    }).sort({ date: 1 });
    console.log(schedules);
    if (schedules.length > 0) {
      res.status(200).json(schedules);
    } else {
      res.status(404).json({ message: "No schedules found for this month" });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: " Server error occured" });
  }
};

exports.createScheduleAndNotification = async (req, res) => {
  try {
    const { schedule, notification } = req.body;
    const profInfo = await User.findOne({ school_id: schedule.prof_id });

    const newSchedule = new Schedule({
      school_id: schedule.school_id,
      room: schedule.room,
      block: schedule.block,
      task: schedule.task,
      prof_id: schedule.prof_id,
      professor: `${profInfo.first_name} ${profInfo.last_name}`,
      department: schedule.department,
      time_in: schedule.time_in,
      time_out: schedule.time_out,
      date: schedule.date,
      isActive: schedule.isActive,
      isCompleted: schedule.isCompleted || "pending",
    });

    const savedSchedule = await newSchedule.save();
    const receiverId = savedSchedule.school_id;

    const newNotification = new Notifications({
      sender: notification.sender,
      senderName: notification.senderName,
      receiver: savedSchedule.school_id,
      receiverName: notification.receiverName,
      role: notification.role,
      title: notification.title,
      message:
        `You have been assigned a schedule to professor ${profInfo.first_name} ${profInfo.last_name}'s` +
        `${notification.message}`,
      scheduleId: savedSchedule._id,
      date: new Date().toISOString().split("T")[0], // Current date
      time: new Date().toLocaleTimeString(), // Current time
      status: notification.status,
      profile_picture: notification.profile_picture,
    });

    await newNotification.save();
    const io = req.app.get("io");
    sendNotification(io, receiverId, newNotification);

    res.status(200).json({
      message: `Notification "${notification.title}" has been sent by ${
        notification.senderName
      } to ${notification.receiverName || "all"}.`,
      schedule: savedSchedule,
      notification: newNotification,
    });
  } catch (error) {
    console.error("Error creating schedule or notification:", error);
    res.status(500).json({ message: error.message });
  }
};

// Delete a schedule
exports.deleteScheduleAndNotification = async (req, res) => {
  const { scheduleId, school_id } = req.body;
  console.log(`SCHEDULE ID LOG ${req.body.scheduleId}`);
  try {
    let result;
    const schedule = await Schedule.findOne({ _id: scheduleId });
    const admin = await User.findOne({ school_id: "03-0000-00003" });
    const bot = await User.findOne({ school_id: "00-0000-00000" });
    const user = await User.findOne({ school_id: schedule.school_id });
    const prof = await User.findOne({ school_id: schedule.prof_id });
    const io = req.app.get("io");
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
      result = await Notifications.updateOne(
        { scheduleId: scheduleId },
        { $set: { scheduleId: "" } },
        { new: true, runValidators: true }
      );
      await profNotification.save();
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

      sendNotification(io, admin.school_id, adminNotification);
      sendNotification(io, prof.school_id, profNotification);
    } else {
      result = await Notifications.updateOne(
        { scheduleId: scheduleId },
        { $set: { scheduleId: "" } },
        { new: true, runValidators: true }
      );
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
      sendNotification(io, admin.school_id, adminNotification);
      sendNotification(io, prof.school_id, profNotification);
    }
    res.status(200).json({
      message: `Record with schedule ID #${scheduleId} has been deleted.`,
    });
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
  const prof = await User.findOne({ school_id: params.prof_id });
  console.log(prof.first_name + prof.last_name);
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
        professor: prof ? `${prof.first_name} ${prof.last_name}` : "",
        prof_id: params.prof_id,
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

console.log(`Date: ${currentDate}`);
console.log(`Time: ${currentTime}`);

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
