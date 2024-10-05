const pool = require('../db');
const Schedule = require('../models/schedule_model');
const Post = require('../models/posts_model');
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

  exports.createPost = async (req, res) => {
    console.log("createPost HIT");
    try {
      const loggedInProfId = req.userSchoolId; 
      console.log('Logged In Prof ID:', loggedInProfId);
  
      const schedules = await Schedule.find({ prof_id: loggedInProfId }).select('school_id');
  
      if (schedules.length === 0) {
        return res.status(404).json({ message: 'No schedules found for this professor.' });
      }
  
      // Fetch existing posts for the logged-in professor to prevent duplicates
      const existingPosts = await Post.find({
        prof_id: loggedInProfId,
        title: req.body.title,
        body: req.body.body,
        school_id: { $in: schedules.map(schedule => schedule.school_id) } // Match against all relevant school_ids
      });
  
      // Map over schedules and filter out any duplicates based on existing posts
      const postsData = schedules.reduce((acc, schedule) => {
        const schoolId = schedule.school_id;
        const alreadyExists = existingPosts.some(post => post.school_id === schoolId);
  
        if (!alreadyExists) {
          acc.push({
            title: req.body.title,  
            body: req.body.body, 
            status: req.body.status || 'Active', 
            school_id: schoolId, 
            prof_id: loggedInProfId,   
          });
        }
  
        return acc;
      }, []);
  
      // Only insert if there are new posts to add
      if (postsData.length > 0) {
        await Post.insertMany(postsData);
        res.status(200).json({ message: `Posts created successfully for all school_ids.` });
      } else {
        res.status(200).json({ message: `No new posts to create. Duplicate messages detected.` });
      }
    } catch (error) {
      console.error('Error creating posts:', error);
      res.status(500).json({ message: 'Server error. Unable to create posts.' });
    }
  };
  

//Get user posts
exports.getUserPosts = (req, res) => {
  pool.getConnection((error, connection) => {
      if (error) throw error;
      console.log(`connected as id ${connection.threadId}`);

      connection.query('SELECT * FROM posts WHERE school_id = ?', [req.params.school_id], (error, rows) => {
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

//Update post
exports.updatePost = (req, res) => {
  pool.getConnection((error, connection) => {
      if (error) {
          console.error('Error getting connection:', error);
          return res.status(500).json({ message: 'Error connecting to the database' });
      }

      console.log(`Connected as id ${connection.threadId}`);

      const id = req.params.id; 
      const params = req.body; 

      // Debugging output
      console.log('ID from params:', id);
      console.log('Params from body:', params);

      if (!id) {
          return res.status(400).json({ message: 'ID is required as a URL parameter' });
      }

      connection.query('UPDATE posts SET ? WHERE id = ?', [params, id], (error, results) => {
          connection.release();

          if (error) {
              console.error('Error executing query:', error);
              return res.status(500).json({ message: 'Database query error' });
          }

          console.log('Query Results:', results);

          if (results.affectedRows === 0) {
              return res.status(404).json({ message: `No record found with ID ${id}.` });
          }

          res.status(200).json({ message: `Post with ID ${id} has been updated.` });
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

//Get Profs Schedule
exports.getProfSchedule = (req, res) => {
  pool.getConnection((error, connection) => {
    if (error) {
      console.error('Error getting MySQL connection:', error);
      return res.status(500).json({ message: 'Server error occurred' });
    }

    console.log(`Connected as id ${connection.threadId}`);

    connection.query('SELECT * FROM schedule WHERE prof_id = ?', [req.params.prof_id], (error, rows) => {
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








