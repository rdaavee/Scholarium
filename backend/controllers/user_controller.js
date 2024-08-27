const mysql = require('mysql');
const pool = mysql.createPool({
  connectionLimit: 10,
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'ishkolarium'
});
const moment = require('moment');

//Get Announcement
exports.getAnnouncements = (req, res) => {
  pool.getConnection((error, connection) => {
      if (error) throw error;
      console.log(`connected as id ${connection.threadId}`);

      connection.query('SELECT * from announcements', (error, rows) => {
          connection.release();

          if (!error) {
              res.status(200).json(rows);
          } else {
              console.log(error)
              res.status(500).json(error);
          };
      });
  });
};

//Get Latest Announcement
exports.getLatestAnnouncement = (req, res) => {
  pool.getConnection((error, connection) => {
    if (error) {
      console.error('Error getting database connection:', error);
      return res.status(500).json({ error: 'Internal Server Error' });
    }
    console.log(`Connected as id ${connection.threadId}`);

    connection.query(
      'SELECT * FROM announcements ORDER BY date DESC, time DESC',
      (error, result) => {
        connection.release();

        if (error) {
          console.error('Error executing query:', error);
          return res.status(500).json({ error: 'Internal Server Error' });
        }

        if (result.length > 0) {
          const latestAnnouncement = result[0];
          const announcementDate = moment(latestAnnouncement.date); // Assuming date is stored in 'YYYY-MM-DD' format
          const currentDate = moment().format('YYYY-MM-DD'); // Get today's date in 'YYYY-MM-DD' format

          if (announcementDate.isSame(currentDate)) {
            res.status(200).json(latestAnnouncement);
          } else {
            res.status(204).json({ message: 'No data today' });
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

      connection.query('SELECT * from posts WHERE status = ?',[req.params.status], (error, rows) => {
          connection.release();

          if (!error) {
              res.status(200).json(rows);
          } else {
              console.log(error)
              res.status(500).json(error);
          };
      });
  });
};

//Get specific user
exports.getUserProfile = (req, res) => {
  pool.getConnection((error, connection) => {
    if (error) {
      console.error('Error getting MySQL connection:', error);
      return res.status(500).json({ message: 'Server error occurred' });
    }

    console.log(`Connected as id ${connection.threadId}`);

    connection.query('SELECT * FROM users WHERE token = ?', [req.params.token], (error, rows) => {
      connection.release();

      if (error) {
        console.error('Error executing query:', error);
        return res.status(500).json({ message: 'Server error occurred' });
      }

      if (rows.length > 0) {
        res.status(200).json(rows[0]);
      } else {
        res.status(404).json({ message: 'User not found' });
      }
    });
  });
};

//Get User Schedule
exports.getUserSchedule = (req, res) => {
  pool.getConnection((error, connection) => {
    if (error) {
      console.error('Error getting MySQL connection:', error);
      return res.status(500).json({ message: 'Server error occurred' });
    }

    console.log(`Connected as id ${connection.threadId}`);

    connection.query('SELECT * FROM schedule WHERE school_id = ?', [req.params.school_id], (error, rows) => {
      connection.release();

      if (error) {
        console.error('Error executing query:', error);
        return res.status(500).json({ message: 'Server error occurred' });
      }

      if (rows.length > 0) {
        res.status(200).json(rows);
      } else {
        res.status(404).json({ message: 'User schedule not found' });
      }
    });
  });
};

//Get User DTR
exports.getUserDTR = (req, res) => {
  pool.getConnection((error, connection) => {
    if (error) {
      console.error('Error getting MySQL connection:', error);
      return res.status(500).json({ message: 'Server error occurred' });
    }

    console.log(`Connected as id ${connection.threadId}`);

    connection.query('SELECT * FROM dtr WHERE school_id = ?', [req.params.token], (error, rows) => {
      connection.release();

      if (error) {
        console.error('Error executing query:', error);
        return res.status(500).json({ message: 'Server error occurred' });
      }

      if (rows.length > 0) {
        res.status(200).json(rows);
      } else {
        res.status(404).json({ message: 'User dtr not found' });
      }
    });
  });
};

exports.getUserTotalHours = (req, res) => {
  const token = req.params.token;

  // Step 1: Validate the Token and Get User ID
  pool.getConnection((error, connection) => {
    if (error) {
      console.error('Error getting MySQL connection:', error);
      return res.status(500).json({ message: 'Server error occurred' });
    }

    console.log(`Connected as id ${connection.threadId}`);

    connection.query('SELECT school_id FROM users WHERE token = ?', [token], (error, userResult) => {
      if (error) {
        connection.release();
        console.error('Error executing query:', error);
        return res.status(500).json({ message: 'Server error occurred' });
      }

      

      const student_id = userResult[0].school_id;

      connection.query('SELECT SUM(hours_rendered) AS total_hours, hours_to_rendered AS target_hours FROM dtr WHERE school_id = ?', [student_id], (error, result) => {
        connection.release();

        if (error) {
          console.error('Error executing query:', error);
          return res.status(500).json({ message: 'Server error occurred' });
        }

        if (result[0].total_hours != null) {
          res.status(200).json({ totalhours: result[0].total_hours, targethours: result[0].target_hours });
        } else {
          res.status(404).json({ message: 'No hours rendered found for this user' });
        }
      });
    });
  });
};






