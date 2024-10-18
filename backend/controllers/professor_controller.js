const pool = require("../db");
const Schedule = require("../models/schedule_model");
const Notification = require("../models/notifications_model");
const Post = require("../models/posts_model");
const User = require("../models/user_model");
const DTR = require("../models/dtr_model");
const moment = require("moment");
const admin = require("firebase-admin");
const { v4: uuidv4 } = require("uuid");
const Notifications = require("../models/notifications_model");

const currentDate = moment().format("YYYY-MM-DD");
const currentTime = moment().format("HH:mm:ss");

exports.getProfTodaySchedule = async (req, res) => {
  const { prof_id } = req.params;
  const today = moment().format("YYYY-MM-DD");

  try {
    const schedules = await Schedule.find({
      prof_id: prof_id,
      date: today,
    });

    if (schedules.length === 0) {
      return res.status(404).json({ message: "No schedules found for today." });
    }

    const groupedSchedules = {};

    for (const schedule of schedules) {
      const { time_in, time_out, room } = schedule;
      const timeKey = `${time_in}-${time_out}`;

      if (!groupedSchedules[timeKey]) {
        groupedSchedules[timeKey] = {
          room: room,
          date: schedule.date,
          time_in: time_in,
          time_out: time_out,
          students: [],
        };
      }

      const matchingSchedules = await Schedule.find({
        time_in: schedule.time_in,
        time_out: schedule.time_out,
        date: schedule.date,
        room: schedule.room,
      });

      for (const match of matchingSchedules) {
        const existingStudent = groupedSchedules[timeKey].students.find(
          (student) => student.school_id === match.school_id
        );

        if (!existingStudent) {
          const user = await User.findOne(
            { school_id: match.school_id },
            "school_id profile_picture"
          );

          if (user) {
            groupedSchedules[timeKey].students.push({
              school_id: user.school_id,
              profile_picture: user.profile_picture,
            });
          }
        }
      }
    }

    // Map the grouped schedules to the required format
    const responseSchedules = Object.entries(groupedSchedules).map(
      ([timeKey, details]) => ({
        time_in: details.time_in,
        time_out: details.time_out,
        room: details.room,
        date: details.date,
        students: details.students,
      })
    );

    return res.json({ schedules: responseSchedules });
  } catch (error) {
    console.error("Error fetching schedules:", error);
    return res.status(500).json({ message: "Internal server error." });
  }
};


//Get Announcement
exports.getAnnouncements = (req, res) => {
  pool.getConnection((error, connection) => {
    if (error) throw error;
    console.log(`connected as id ${connection.threadId}`);

    connection.query("SELECT * from announcements", (error, rows) => {
      connection.release();

      if (!error) {
        res.status(200).json(rows);
      } else {
        console.log(error);
        res.status(500).json(error);
      }
    });
  });
};

exports.createNotification = async (req, res) => {
  console.log("createNotification HIT");
  try {
    const loggedInProfId = req.userSchoolId;
    console.log("Logged In Prof ID:", loggedInProfId);

    const senderInfo = await User.findOne({ school_id: loggedInProfId }).select(
      "first_name last_name role"
    );
    if (!senderInfo) {
      return res.status(404).json({ message: "Sender not found." });
    }
    const senderName = `${senderInfo.first_name} ${senderInfo.last_name}`;
    console.log("Sender Name:", senderName);

    const schedules = await Schedule.find({ prof_id: loggedInProfId }).select(
      "school_id"
    );
    if (schedules.length === 0) {
      return res
        .status(404)
        .json({ message: "No schedules found for this professor." });
    }

    // Extract unique school IDs
    const schoolIds = [
      ...new Set(schedules.map((schedule) => schedule.school_id)),
    ];
    console.log("Unique School IDs:", schoolIds);

    // Create notifications directly based on unique school IDs
    const notificationsData = await Promise.all(
      schoolIds.map(async (schoolId) => {
        const receiverInfo = await User.findOne({ school_id: schoolId }).select(
          "first_name last_name"
        );
        const receiverName = receiverInfo
          ? `${receiverInfo.first_name} ${receiverInfo.last_name}`
          : null;

        const now = new Date();
        const date = now.toISOString().split("T")[0];
        const time = now.toTimeString().split(" ")[0];

        return {
          sender: loggedInProfId,
          senderName: senderName,
          receiver: schoolId,
          receiverName: receiverName,
          role: senderInfo.role,
          title: req.body.title,
          message: req.body.message,
          status: req.body.status || false,
          // scheduleId: schedules.find(schedule => schedule.school_id === schoolId)?._id || null,
          isActive: true,
          date: date,
          time: time,
        };
      })
    );

    // Filter out any null values from the notifications data
    const filteredNotifications = notificationsData.filter(
      (notification) => notification
    );

    if (filteredNotifications.length > 0) {
      // Insert notifications into the database
      await Notification.insertMany(filteredNotifications);
      res.status(200).json({
        message: `Notifications created successfully for all school_ids.`,
      });
    } else {
      res.status(200).json({
        message: `No new notifications to create.`,
      });
    }
  } catch (error) {
    console.error("Error creating notifications:", error);
    res
      .status(500)
      .json({ message: "Server error. Unable to create notifications." });
  }
};

//Get user posts
exports.getUserPosts = (req, res) => {
  pool.getConnection((error, connection) => {
    if (error) throw error;
    console.log(`connected as id ${connection.threadId}`);

    connection.query(
      "SELECT * FROM posts WHERE school_id = ?",
      [req.params.school_id],
      (error, rows) => {
        connection.release();

        if (!error) {
          res.status(200).json(rows);
        } else {
          console.log(error);
          res.status(500).json(error);
        }
      }
    );
  });
};

// Get User Schedule
exports.getProfSchedule = async (req, res) => {
  const month = req.params.month;

  try {
    const user = await User.findById(req.userId);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const prof_id = user.school_id;
    await updatePastSchedules(prof_id);

    const startOfMonth = moment(month).startOf("month").format("YYYY-MM-DD");
    const endOfMonth = moment(month).endOf("month").format("YYYY-MM-DD");

    const schedules = await Schedule.aggregate([
      {
        $match: {
          prof_id: prof_id,
          date: { $gte: startOfMonth, $lte: endOfMonth },
        },
      },
      {
        $lookup: {
          from: "users",
          localField: "school_id",
          foreignField: "school_id",
          as: "user_info",
        },
      },
      {
        $unwind: "$user_info",
      },
      {
        $project: {
          _id: 1,
          room: 1,
          block: 1,
          task: 1,
          professor: 1,
          department: 1,
          time_in: 1,
          time_out: 1,
          date: 1,
          isActive: 1,
          completed: 1,
          "user_info.school_id": 1,
          "user_info.first_name": 1,
          "user_info.last_name": 1,
          "user_info.hk_type": 1,
        },
      },
      {
        $sort: { date: 1 },
      },
    ]);

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

const updatePastSchedules = async (prof_id) => {
  try {
    const currentDate = moment().startOf("day").format("YYYY-MM-DD");

    await Schedule.updateMany(
      {
        prof_id: prof_id,
        date: { $lt: currentDate },
        completed: { $ne: "true" },
      },
      { $set: { completed: "false" } }
    );

    console.log("Past schedules updated successfully.");
  } catch (error) {
    console.error("Error updating past schedules:", error);
    throw new Error("Error updating past schedules");
  }
};
exports.updateStudentsSchedules = async (req, res) => {
  const { id } = req.params;

  try {
    if (!id) {
      return res.status(400).json({ message: "Schedule ID is required" });
    }

    const updatedSchedule = await Schedule.findByIdAndUpdate(
      id,
      { completed: "true" },
      { new: true }
    );

    if (!updatedSchedule) {
      return res.status(404).json({ message: "Schedule not found" });
    }

    res.status(200).json({
      message: "Schedule updated successfully",
      schedule: updatedSchedule,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error occurred" });
  }
};

exports.createDTR = async (req, res) => {
  const {
    school_id,
    date,
    time_in,
    time_out,
    hours_rendered,
    hours_to_rendered,
    remarks,
    professor,
    professor_signature,
  } = req.body;
  console.log(req.body);

  try {
    const base64Image = professor_signature.split(";base64,").pop();
    const buffer = Buffer.from(base64Image, "base64");

    const filename = `professor_signature_${uuidv4()}.png`;

    const bucket = admin.storage().bucket();
    const file = bucket.file(filename);
    await file.save(buffer, {
      metadata: { contentType: "image/png" },
      public: true,
    });

    const imageUrl = `https://storage.googleapis.com/${bucket.name}/${filename}`;

    const newDTR = new DTR({
      school_id,
      date,
      time_in,
      time_out,
      hours_rendered,
      hours_to_rendered,
      remarks,
      professor,
      professor_signature: imageUrl,
    });

    const savedRecord = await newDTR.save();

    const user = await User.findOne({ school_id: school_id });
    const bot = await User.findOne({ school_id: "00-0000-00000" });

    const newNotification = new Notifications({
      sender: bot.school_id,
      senderName: bot.first_name + " " + bot.last_name,
      receiver: user.school_id,
      receiverName: user.first_name + " " + user.last_name,
      role: "Bot",
      title: "Duty Alert",
      message: `Dear ${user.first_name}, you have successfully completed your duty on ${date} at ${time_out}. Please check your records for more details.`,
      scheduleId: "",
      date: currentDate,
      time: currentTime,
      status: false,
      profile_picture: bot.profile_picture,
    });

    await newNotification.save();
    console.log(newNotification)
    res.status(200).json({
      message: "DTR created successfully",
      record: savedRecord,
      notification: newNotification,
    });
  } catch (error) {
    console.error(error);
    res
      .status(500)
      .json({ message: "Server error occurred", error: error.message });
  }
};

//Update post
exports.updatePost = (req, res) => {
  pool.getConnection((error, connection) => {
    if (error) {
      console.error("Error getting connection:", error);
      return res
        .status(500)
        .json({ message: "Error connecting to the database" });
    }

    console.log(`Connected as id ${connection.threadId}`);

    const id = req.params.id;
    const params = req.body;

    // Debugging output
    console.log("ID from params:", id);
    console.log("Params from body:", params);

    if (!id) {
      return res
        .status(400)
        .json({ message: "ID is required as a URL parameter" });
    }

    connection.query(
      "UPDATE posts SET ? WHERE id = ?",
      [params, id],
      (error, results) => {
        connection.release();

        if (error) {
          console.error("Error executing query:", error);
          return res.status(500).json({ message: "Database query error" });
        }

        console.log("Query Results:", results);

        if (results.affectedRows === 0) {
          return res
            .status(404)
            .json({ message: `No record found with ID ${id}.` });
        }

        res
          .status(200)
          .json({ message: `Post with ID ${id} has been updated.` });
      }
    );
  });
};

//Get specific user
exports.getUserProfile = (req, res) => {
  pool.getConnection((error, connection) => {
    if (error) {
      console.error("Error getting MySQL connection:", error);
      return res.status(500).json({ message: "Server error occurred" });
    }

    console.log(`Connected as id ${connection.threadId}`);

    connection.query(
      "SELECT * FROM users WHERE token = ?",
      [req.params.token],
      (error, rows) => {
        connection.release();

        if (error) {
          console.error("Error executing query:", error);
          return res.status(500).json({ message: "Server error occurred" });
        }

        if (rows.length > 0) {
          res.status(200).json(rows[0]);
        } else {
          res.status(404).json({ message: "User not found" });
        }
      }
    );
  });
};
