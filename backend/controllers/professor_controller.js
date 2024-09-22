const pool = require('../db');
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

//Create post
exports.createPost = (req, res) => {
    pool.getConnection((error, connection) => {
        if (error) throw error;
        console.log(`connected as id ${connection.threadId}`);

        const params = req.body;

        connection.query('INSERT INTO posts SET ?', params, (error, rows) => {
            connection.release();

            if (!error) {
                res.status(200).json({ message: `Record of "${params.title}" has been added.` });
            } else {
                console.log(error);
                res.status(500).json({ message: error});
            };
        });
    });
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








