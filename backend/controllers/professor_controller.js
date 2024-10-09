const pool = require("../db");
const Schedule = require("../models/schedule_model");
const Post = require("../models/posts_model");
const User = require("../models/user_model");
const DTR = require("../models/dtr_model")
const moment = require("moment");
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

exports.createPost = async (req, res) => {
  console.log("createPost HIT");
  try {
    const loggedInProfId = req.userSchoolId;
    console.log("Logged In Prof ID:", loggedInProfId);

    const schedules = await Schedule.find({ prof_id: loggedInProfId }).select(
      "school_id"
    );

    if (schedules.length === 0) {
      return res
        .status(404)
        .json({ message: "No schedules found for this professor." });
    }

    // Fetch existing posts for the logged-in professor to prevent duplicates
    const existingPosts = await Post.find({
      prof_id: loggedInProfId,
      title: req.body.title,
      body: req.body.body,
      school_id: { $in: schedules.map((schedule) => schedule.school_id) }, // Match against all relevant school_ids
    });

    // Map over schedules and filter out any duplicates based on existing posts
    const postsData = schedules.reduce((acc, schedule) => {
      const schoolId = schedule.school_id;
      const alreadyExists = existingPosts.some(
        (post) => post.school_id === schoolId
      );

      if (!alreadyExists) {
        acc.push({
          title: req.body.title,
          body: req.body.body,
          status: req.body.status || "Active",
          school_id: schoolId,
          prof_id: loggedInProfId,
        });
      }

      return acc;
    }, []);

    // Only insert if there are new posts to add
    if (postsData.length > 0) {
      await Post.insertMany(postsData);
      res
        .status(200)
        .json({ message: `Posts created successfully for all school_ids.` });
    } else {
      res.status(200).json({
        message: `No new posts to create. Duplicate messages detected.`,
      });
    }
  } catch (error) {
    console.error("Error creating posts:", error);
    res.status(500).json({ message: "Server error. Unable to create posts." });
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
          subject: 1,
          professor: 1,
          department: 1,
          time: 1,
          date: 1,
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
    const currentDate = moment().startOf("day").format("YYYY-MM-DD"); // Get the current date

    // Find schedules where the date is in the past and completed is not "true"
    await Schedule.updateMany(
      {
        prof_id: prof_id,
        date: { $lt: currentDate }, // Dates in the past
        completed: { $ne: "true" }, // Only update if not already "true"
      },
      { $set: { completed: "false" } } // Set 'completed' to 'false'
    );

    console.log("Past schedules updated successfully.");
  } catch (error) {
    console.error("Error updating past schedules:", error);
    throw new Error("Error updating past schedules"); // Handle this error in the calling function
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
    professor,
    professor_signature,
  } = req.body;

  try {
    const newDTR = new DTR({
      school_id,
      date,
      time_in,
      time_out,
      hours_rendered,
      hours_to_rendered,
      professor,
      professor_signature,
    });


    const savedRecord = await newDTR.save();

    res.status(200).json({
      message: "DTR created successfully",
      record: savedRecord,
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
