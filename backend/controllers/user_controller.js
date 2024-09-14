const mysql = require("mysql");
const pool = mysql.createPool({
  connectionLimit: 10,
  host: "localhost",
  user: "root",
  password: "",
  database: "ishkolarium",
});
const moment = require("moment");

//-------------------------------------FOR STUDENT HOME PAGE-------------------------------------------------------
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

//Get Latest Announcement
exports.getLatestAnnouncement = (req, res) => {
  pool.getConnection((error, connection) => {
    if (error) {
      console.error("Error getting database connection:", error);
      return res.status(500).json({ error: "Internal Server Error" });
    }
    console.log(`Connected as id ${connection.threadId}`);

    connection.query(
      "SELECT * FROM announcements ORDER BY date DESC, time DESC",
      (error, result) => {
        connection.release();

        if (error) {
          console.error("Error executing query:", error);
          return res.status(500).json({ error: "Internal Server Error" });
        }

        if (result.length > 0) {
          const latestAnnouncement = result[0];
          const announcementDate = moment(latestAnnouncement.date); // Assuming date is stored in 'YYYY-MM-DD' format
          const currentDate = moment().format("YYYY-MM-DD"); // Get today's date in 'YYYY-MM-DD' format

          if (announcementDate.isSame(currentDate)) {
            res.status(200).json(latestAnnouncement);
          } else {
            res.status(204).json({ message: "No data today" });
          }
        }
      }
    );
  });
};

//Get posts
exports.getPosts = (req, res) => {
  pool.getConnection((error, connection) => {
    if (error) throw error;
    console.log(`connected as id ${connection.threadId}`);

    connection.query(
      "SELECT * from posts WHERE status = ?",
      [req.params.status],
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

//Get User Schedule
exports.getUserSchedule = (req, res) => {
  const token = req.params.token;
  pool.getConnection((error, connection) => {
    if (error) {
      console.error("Error getting MySQL connection:", error);
      return res.status(500).json({ message: "Server error occurred" });
    }
    connection.query(
      "SELECT school_id FROM users WHERE token = ?",
      [token],
      (error, userResult) => {
        if (error) {
          connection.release();
          console.error("Error executing query:", error);
          return res.status(500).json({ message: "Server error occurred" });
        }
        if (userResult.length === 0) {
          connection.release();
          return res.status(404).json({ message: "User not found" });
        }
        const school_id = userResult[0].school_id;
        connection.query(
          "SELECT * FROM schedule WHERE school_id = ?",
          [school_id],
          (error, rows) => {
            if (error) {
              connection.release();
              console.error("Error executing query:", error);
              return res.status(500).json({ message: "Server error occurred" });
            }
            if (rows.length > 0) {
              const currentDate = moment().startOf('day');
              let updatePromises = [];
              rows.forEach((schedule) => {
                const scheduleDate = moment(schedule.date).startOf('day');
                if (schedule.completed === '' && scheduleDate.isBefore(currentDate)) {
                  const updateQuery = new Promise((resolve, reject) => {
                    connection.query(
                      "UPDATE schedule SET completed = 'false' WHERE id = ?",
                      [schedule.id],
                      (error) => {
                        if (error) {
                          reject(error);
                        } else {
                          resolve();
                        }
                      }
                    );
                  });
                  updatePromises.push(updateQuery);
                }
              });
              Promise.all(updatePromises)
                .then(() => {
                  connection.release();
                  res.status(200).json(rows);
                })
                .catch((err) => {
                  connection.release();
                  console.error("Error updating schedules:", err);
                  res.status(500).json({ message: "Error updating schedules" });
                });
            } else {
              connection.release();
              res.status(404).json({ message: "User schedule not found" });
            }
          }
        );
      }
    );
  });
};


//Get User DTR
exports.getUserDTR = (req, res) => {
  pool.getConnection((error, connection) => {
    if (error) {
      console.error("Error getting MySQL connection:", error);
      return res.status(500).json({ message: "Server error occurred" });
    }

    console.log(`Connected as id ${connection.threadId}`);

    connection.query(
      "SELECT school_id, password FROM users WHERE token = ?",
      [req.params.token],
      (error, userResult) => {
        if (error) {
          connection.release();
          console.error("Error executing query:", error);
          return res.status(500).json({ message: "Server error occurred" });
        }

        if (userResult.length === 0) {
          connection.release();
          return res.status(404).json({ message: "User not found" });
        }

        const { school_id } = userResult[0];

        connection.query(
          "SELECT * FROM dtr WHERE school_id = ?",
          [school_id],
          (error, rows) => {
            connection.release();

            if (error) {
              console.error("Error executing query:", error);
              return res.status(500).json({ message: "Server error occurred" });
            }

            if (rows.length > 0) {
              res.status(200).json(rows);
            } else {
              res.status(404).json({ message: "User dtr not found" });
            }
          }
        );
      }
    );
  });
};


exports.getUserTotalHours = (req, res) => {
  const token = req.params.token;

  // Step 1: Validate the Token and Get User ID
  pool.getConnection((error, connection) => {
    if (error) {
      console.error("Error getting MySQL connection:", error);
      return res.status(500).json({ message: "Server error occurred" });
    }

    console.log(`Connected as id ${connection.threadId}`);

    connection.query(
      "SELECT school_id FROM users WHERE token = ?",
      [token],
      (error, userResult) => {
        if (error) {
          connection.release();
          console.error("Error executing query:", error);
          return res.status(500).json({ message: "Server error occurred" });
        }

        const student_id = userResult[0].school_id;

        connection.query(
          "SELECT SUM(hours_rendered) AS total_hours, hours_to_rendered AS target_hours FROM dtr WHERE school_id = ?",
          [student_id],
          (error, result) => {
            connection.release();

            if (error) {
              console.error("Error executing query:", error);
              return res.status(500).json({ message: "Server error occurred" });
            }

            if (result[0].total_hours != null) {
              res.status(200).json({
                totalhours: result[0].total_hours,
                targethours: result[0].target_hours,
              });
            } else {
              res
                .status(404)
                .json({ message: "No hours rendered found for this user" });
            }
          }
        );
      }
    );
  });
};

//-------------------------------------FOR STUDENT NOTIFICATIONS PAGE-----------------------------------------------------
//Get Student Notifications
exports.getUserNotifications = (req, res) => {
  pool.getConnection((error, connection) => {
    if (error) {
      console.error("Error getting MySQL connection:", error);
      return res.status(500).json({ message: "Server error occurred" });
    }

    console.log(`Connected as id ${connection.threadId}`);

    connection.query(
      "SELECT school_id, password FROM users WHERE token = ?",
      [req.params.token],
      (error, userResult) => {
        if (error) {
          connection.release();
          console.error("Error executing query:", error);
          return res.status(500).json({ message: "Server error occurred" });
        }

        if (userResult.length === 0) {
          connection.release();
          return res.status(404).json({ message: "User not found" });
        }

        const { school_id } = userResult[0];

        connection.query(
          "SELECT * FROM notifications WHERE school_id = ?",
          [school_id],
          (error, rows) => {
            connection.release();

            if (error) {
              console.error("Error executing query:", error);
              return res.status(500).json({ message: "Server error occurred" });
            }

            if (rows.length > 0) {
              res.status(200).json(rows);
            } else {
              res.status(404).json({ message: "User dtr not found" });
            }
          }
        );
      }
    );
  });
};

// Update Notification Status to Read or unread
exports.updateNotificationStatus = (req, res) => {
  const notificationId = req.params.id;

  pool.getConnection((error, connection) => {
    if (error) {
      console.error('Error getting MySQL connection:', error);
      return res.status(500).json({ message: 'Server error occurred' });
    }

    console.log(`Connected as id ${connection.threadId}`);

    connection.query(
      'UPDATE notifications SET status = ? WHERE id = ?',
      ['read', notificationId],
      (error, results) => {
        connection.release();

        if (error) {
          console.error('Error executing query:', error);
          return res.status(500).json({ message: 'Server error occurred' });
        }

        if (results.affectedRows > 0) {
          res.status(200).json({ message: 'Notification status updated to read' });
        } else {
          res.status(404).json({ message: 'Notification not found' });
        }
      }
    );
  });
};



//-------------------------------------FOR STUDENT PROFILE PAGE-----------------------------------------------------
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
          const user = rows[0];
          const baseUrl = "http://192.168.42.137:3000"; // Update this with your server's base URL

          res.status(200).json({
            id: user.id,
            school_id: user.school_id,
            email: user.email,
            first_name: user.first_name,
            middle_name: user.middle_name,
            last_name: user.last_name,
            profile_picture: user.profile_picture
              ? `${baseUrl}/uploads/profile_pictures/${user.profile_picture}`
              : null, // Include full URL
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
      }
    );
  });
};

// Change Password
// exports.changePassword = (req, res) => {
//   const { oldPassword, newPassword, confirmPassword } = req.body;
//   const token = req.params.token;

//   if (!oldPassword || !newPassword || !confirmPassword) {
//     return res.status(400).json({ message: 'Please provide all password fields' });
//   }

//   if (newPassword !== confirmPassword) {
//     return res.status(400).json({ message: 'New password and confirm password do not match' });
//   }

//   pool.getConnection((error, connection) => {
//     if (error) {
//       console.error('Error getting MySQL connection:', error);
//       return res.status(500).json({ message: 'Server error occurred' });
//     }

//     console.log(`Connected as id ${connection.threadId}`);

//     connection.query('SELECT school_id, password FROM users WHERE token = ?', [token], (error, userResult) => {
//       if (error) {
//         connection.release();
//         console.error('Error executing query:', error);
//         return res.status(500).json({ message: 'Server error occurred' });
//       }

//       if (userResult.length === 0) {
//         connection.release();
//         return res.status(404).json({ message: 'User not found' });
//       }

//       const { school_id, password: storedPasswordHash } = userResult[0];

// Compare old password with the stored password hash
//       bcrypt.compare(oldPassword, storedPasswordHash, (err, isMatch) => {
//         if (err) {
//           connection.release();
//           console.error('Error comparing passwords:', err);
//           return res.status(500).json({ message: 'Server error occurred' });
//         }

//         if (!isMatch) {
//           connection.release();
//           return res.status(400).json({ message: 'Old password is incorrect' });
//         }

// Hash the new password before storing
//         bcrypt.hash(newPassword, 10, (err, newPasswordHash) => {
//           if (err) {
//             connection.release();
//             console.error('Error hashing new password:', err);
//             return res.status(500).json({ message: 'Server error occurred' });
//           }

// Update the user's password in the database
//           connection.query('UPDATE users SET password = ? WHERE school_id = ?', [newPasswordHash, school_id], (error, results) => {
//             connection.release();

//             if (error) {
//               console.error('Error updating password:', error);
//               return res.status(500).json({ message: 'Server error occurred' });
//             }

//             res.status(200).json({ message: 'Password has been successfully updated' });
//           });
//         });
//       });
//     });
//   });
// };

// Change Password
exports.updatePassword = (req, res) => {
  const { oldPassword, newPassword, confirmPassword } = req.body;
  const token = req.params.token;

  if (!oldPassword || !newPassword || !confirmPassword) {
    return res
      .status(400)
      .json({ message: "Please provide all password fields" });
  }

  if (newPassword !== confirmPassword) {
    return res
      .status(400)
      .json({ message: "New password and confirm password do not match" });
  }

  pool.getConnection((error, connection) => {
    if (error) {
      console.error("Error getting MySQL connection:", error);
      return res.status(500).json({ message: "Server error occurred" });
    }

    console.log(`Connected as id ${connection.threadId}`);

    // Fetch user based on token
    connection.query(
      "SELECT school_id, password FROM users WHERE token = ?",
      [token],
      (error, userResult) => {
        if (error) {
          connection.release();
          console.error("Error executing query:", error);
          return res.status(500).json({ message: "Server error occurred" });
        }

        if (userResult.length === 0) {
          connection.release();
          return res.status(404).json({ message: "User not found" });
        }

        const { school_id, password: storedPassword } = userResult[0];

        if (oldPassword !== storedPassword) {
          connection.release();
          return res.status(400).json({ message: "Old password is incorrect" });
        }

        connection.query(
          "UPDATE users SET password = ? WHERE school_id = ?",
          [newPassword, school_id],
          (error, results) => {
            connection.release();

            if (error) {
              console.error("Error updating password:", error);
              return res.status(500).json({ message: "Server error occurred" });
            }

            res
              .status(200)
              .json({
                success: true,
                message: "Password has been successfully updated",
              });
          }
        );
      }
    );
  });
};


