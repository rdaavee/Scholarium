const mysql = require('mysql');
const pool = mysql.createPool({
  connectionLimit: 10,
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'scholarium'
});

//Get specific user
exports.getUser = (req, res) => {
  pool.getConnection((error, connection) => {
    if (error) {
      console.error('Error getting MySQL connection:', error);
      return res.status(500).json({ message: 'Server error occurred' });
    }

    console.log(`Connected as id ${connection.threadId}`);

    connection.query('SELECT * FROM users WHERE id = ?', [req.params.id], (error, rows) => {
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

//List all users
exports.getAllUsers = (req, res) => {
  pool.getConnection((error, connection) => {
      if (error) throw error;
      console.log(`connected as id ${connection.threadId}`);

      connection.query('SELECT * from users', (error, rows) => {
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
