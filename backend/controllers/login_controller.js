const mysql = require('mysql');

// Set up MySQL pool
const pool = mysql.createPool({
  connectionLimit: 10,
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'scholarium' // Ensure this matches your actual database name
});

exports.login = (req, res) => {
  pool.getConnection((error, connection) => {
    if (error) {
      console.error('Error getting MySQL connection:', error);
      return res.status(500).json({ message: 'Server error occurred' });
    }

    const { school_id, password } = req.body;

    console.log(`Received login attempt: school_id = ${school_id}, password = ${password}`);

    connection.query('SELECT * FROM users WHERE school_id = ? AND password = ?', [school_id, password], (error, results) => {
      connection.release(); 

      if (error) {
        console.error('Error executing query:', error);
        return res.status(500).json({ message: 'Server error occurred' });
      }

      console.log('Query results:', results);

      if (results.length > 0) {
        const user = results[0];
        res.status(200).json({ message: `Welcome, ${user.first_name} ${user.last_name}` });
      } else {
        res.status(401).json({ message: 'Invalid school ID or password' });
      }
    });
  });
};
