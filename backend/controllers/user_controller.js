const moment = require("moment");
const User = require("../models/user_model");
const Announcement = require("../models/announcement_model");
const Post = require("../models/posts_model");
const Schedule = require("../models/schedule_model");
const DTR = require("../models/dtr_model");
const Notification = require("../models/notifications_model");
const Events = require("../models/events_model");
const currentDate = moment().format("YYYY-MM-DD");
const currentTime = moment().format("HH:mm:ss");

//--------------------------------------------SEND NOTIFICATION FUNCTION-------------------------------------------------------
function sendNotification(io, schoolId, notification) {
  if (connectedUsers[schoolId]) {
    io.of("/notifications")
      .to(connectedUsers[schoolId])
      .emit("receiveNotification", notification);
    console.log(`Notify success for ${schoolId}`);
  } else {
    console.error(`Failed to send notification: Receiver ${schoolId} is not connected.`);
  }
}


// Get Events
exports.fetchEvents = async (req, res) => {
  try {
    const events = await Events.find();
    res.status(200).json(events);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal Server Error" });
  }
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


exports.getLatestAnnouncement = async (req, res) => {
  try {
    const startOfToday = moment().startOf('day');
    const endOfToday = moment().endOf('day');

    const latestAnnouncement = await Announcement.find({
      createdAt: {
        $gte: startOfToday.toDate(),
        $lte: endOfToday.toDate(),
      },
    }).sort({ createdAt: -1 }); 
    console.log(latestAnnouncement);
    if (latestAnnouncement.length > 0) {
      res.status(200).json(latestAnnouncement[0]); 
    } else {
      res.status(204).json({ message: "No announcements for today" });
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
      $or: [{ date: currentDate }, { date: { $gt: currentDate } }],
    }).sort({ date: 1 });

    if (schedules.length > 0) {
      const todaySchedule = schedules.filter((schedule) =>
        moment(schedule.date).isSame(currentDate, "day")
      );
      const nextSchedule = schedules.find((schedule) =>
        moment(schedule.date).isAfter(currentDate)
      );

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
    if (dtrRecords.length >= 0) {
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
      {
        $group: {
          _id: null,
          total_hours: { $sum: "$hours_rendered" },
          target_hours: { $first: "$hours_to_rendered" },
        },
      },
    ]);

    if (result.length > 0) {
      res.status(200).json({
        totalhours: result[0].total_hours,
        targethours: result[0].target_hours,
      });
    } else {
      res
        .status(404)
        .json({ message: "No hours rendered found for this user" });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error occurred" });
  }
};

// Get User Schedule
exports.getUserSchedule = async (req, res) => {
  const month = req.params.month;

  try {
    const user = await User.findById(req.userId);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const school_id = user.school_id;

    await updatePastSchedules(school_id);

    const startOfMonth = moment(month).startOf("month").format("YYYY-MM-DD");
    const endOfMonth = moment(month).endOf("month").format("YYYY-MM-DD");

    const schedules = await Schedule.find({
      school_id: school_id,
      date: { $gte: startOfMonth, $lte: endOfMonth },
    }).sort({ date: 1 });

    const currentDate = moment().startOf("day");
    const updatePromises = schedules.map((schedule) => {
      const scheduleDate = moment(schedule.date);

      if (scheduleDate.isBefore(currentDate) && schedule.completed !== "true") {
        return Schedule.updateOne(
          { _id: schedule._id },
          { completed: "false" }
        );
      }
    });

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

async function updatePastSchedules(school_id) {
  const pastSchedules = await Schedule.find({
    school_id: school_id,
    completed: "pending",
    date: { $lte: currentDate }, 
    time_in: { $lt: currentTime } 
  });

  const updatePromises = pastSchedules.map(async (schedule) => {
    const scheduleTime = moment(schedule.time_in, "HH:mm:ss", true); 
    const scheduleDate = moment(schedule.date, "YYYY-MM-DD", true); 
    
    const scheduleMoment = moment(scheduleDate).set({
      hour: scheduleTime.hour(),
      minute: scheduleTime.minute(),
      second: scheduleTime.second(),
    });

    if (scheduleMoment.isBefore(moment())) {
      if (scheduleDate.format("YYYY-MM-DD") !== currentDate) {
        if (schedule.completed !== "true") {
          await Schedule.updateOne({ _id: schedule._id }, { completed: "false" });
        }
      }

      const user = await User.findOne({ school_id: school_id });
      const bot = await User.findOne({ school_id: "00-0000-00000" });

      const message = `Dear ${user.first_name}, you have not completed your duty on ${schedule.date} at ${schedule.time_in}. Please check your records for more details.`;

      const existingNotification = await Notification.findOne({
        receiver: user.school_id,
        message: message,
        title: "Duty Alert",
      });

      if (!existingNotification) {
        const newNotification = new Notification({
          sender: bot.school_id,
          senderName: `${bot.first_name} ${bot.last_name}`, 
          receiver: user.school_id,
          receiverName: `${user.first_name} ${user.last_name}`, 
          role: "Bot",
          title: "Duty Alert",
          message: message,
          scheduleId: null,
          date: moment().format("YYYY-MM-DD"), 
          time: moment().format("HH:mm:ss"), 
          status: false,
          profile_picture: bot.profile_picture,
        });

        await newNotification.save();
      }
    }
  });

  await Promise.all(updatePromises);
}


exports.getUserNotifications = async (req, res) => {
  try {
    const user = await User.findById(req.userId);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const notifications = await Notification.aggregate([
      {
        $match: {
          receiver: user.school_id,
        },
      },
      {
        $lookup: {
          from: "users",
          localField: "sender",
          foreignField: "school_id",
          as: "sender_info",
        },
      },
      {
        $unwind: {
          path: "$sender_info",
          preserveNullAndEmptyArrays: true,
        },
      },
      {
        $project: {
          _id: 1,
          sender: 1,
          senderName: 1,
          receiver: 1,
          receiverName: 1,
          role: 1,
          title: 1,
          message: 1,
          status: 1,
          scheduleId: 1,
          date: 1,
          time: 1,
          createdAt: 1,
          updatedAt: 1,
          "sender_info.profile_picture": 1,
        },
      },
      {
        $sort: { date: -1, time: -1 },
      },
    ]);

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

exports.getUserUnreadNotifications = async (req, res) => {
  try {
    const user = await User.findById(req.userId);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const unreadNotifications = await Notification.find({
      receiver: user.school_id,
      status: false,
    });
    if (unreadNotifications.length > 0) {
      res.status(200).json(unreadNotifications.length);
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
    const result = await Notification.findByIdAndUpdate(
      notificationId,
      { status: true },
      { new: true, runValidators: true }
    );

    if (result) {
      res.status(200).json({
        message: "Notification status updated to read",
        notification: result,
      });
    } else {
      res.status(404).json({ message: "Notification not found" });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error occurred" });
  }
};

// Delete Notification
exports.deleteNotification = async (req, res) => {
  const notificationId = req.params.id;
  try {
    const result = await Notification.findByIdAndDelete(notificationId);

    if (result) {
      res.status(200).json({
        message: "Notification deleted successfully",
        notification: result,
      });
    } else {
      res.status(404).json({ message: "Notification not found" });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error occurred" });
  }
};


exports.notificationConfirmSched = async (req, res) => {
  const scheduleId = req.params.id;
  try {
    const result = await Schedule.findByIdAndUpdate(
      scheduleId,
      { isActive: true },
      { new: true, runValidators: true }
    );
    if (!result) {
      return res.status(404).json({ message: "Schedule not found." });
    }
    const bot = await User.findOne({school_id: "00-0000-00000"});
    const userInfo = await Notification.findOne({scheduleId: scheduleId}); 
    const profId = await Schedule.findOne({_id: scheduleId}); 
    const adminId = await Notification.findOne({sender: userInfo.sender});
    const adminInfo = await User.findOne({school_id: adminId.sender});
    const senderInfo = await User.findOne({ school_id: userInfo.receiver });
    const receiverInfo = await User.findOne({ school_id: profId.prof_id });
    const now = new Date();
    const date = now.toISOString().split('T')[0];
    const time = now.toTimeString().split(' ')[0];
    const io = req.app.get("io");
    const newNotification = new Notification({
      sender: bot.school_id,
      senderName: `${bot.first_name} ${bot.last_name}`,
      receiver: receiverInfo.school_id,
      receiverName:  `${receiverInfo.first_name} ${receiverInfo.last_name}`,
      role: bot.role,
      title: "Schedule Confirmed!",
      message: `Student ${senderInfo.first_name} ${senderInfo.last_name} has accepted your requested schedule.`,
      scheduleId: "",
      date: date,
      time: time,
      status: false,
    });
    await newNotification.save();
    const adminNotification = new Notification({
      sender: bot.school_id,
      senderName: `${bot.first_name} ${bot.last_name}`,
      receiver: adminInfo.school_id,
      receiverName: `${adminInfo.first_name} ${adminInfo.last_name}`,
      role: bot.role,
      title: "Schedule Confirmed!",
      message: `Student ${senderInfo.first_name} ${senderInfo.last_name} has accepted their schedule towards ${receiverInfo.first_name} ${receiverInfo.last_name}.`,
      scheduleId: "",
      date: date,
      time: time,
      status: false,
    });
    await adminNotification.save();
    sendNotification(io, receiverInfo.school_id, newNotification);
    sendNotification(io, adminInfo.school_id, adminNotification);
    await Notification.updateMany(
      { scheduleId: scheduleId },
      { $set: { scheduleId: "" } }
    );    

    res.status(200).json({ message: "Schedule updated successfully.", schedule: result });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error occurred" });
  }
};

// Get specific user using token
exports.getUserProfile = async (req, res) => {
  try {
    const user = await User.findById(req.userId);
    if (user) {
      res.status(200).json({
        id: user._id,
        school_id: user.school_id,
        email: user.email,
        first_name: user.first_name,
        middle_name: user.middle_name,
        last_name: user.last_name,
        profile_picture: user.profile_picture,
        gender: user.gender,
        contact: user.contact,
        address: user.address,
        role: user.role,
        professor: user.professor,
        prof_id: user.prof_id,
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

// Get specific user using School_id
exports.getUserData = async (req, res) => {
  const { school_id } = req.params;
  try {
    const user = await User.findOne({ school_id: school_id });
    if (user) {
      res.status(200).json({
        id: user._id,
        school_id: user.school_id,
        email: user.email,
        first_name: user.first_name,
        middle_name: user.middle_name,
        last_name: user.last_name,
        profile_picture: user.profile_picture,
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

    res
      .status(200)
      .json({ message: "Password updated successfully", success: true });
  } catch (error) {
    console.error("Error in updatePassword:", error);
    res.status(500).json({ message: "Server error occurred" });
  }
};
