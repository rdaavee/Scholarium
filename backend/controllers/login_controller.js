const mysql = require('mysql');
const jwt = require('jsonwebtoken');
const secretKey = process.env.SECRET_KEY;

// Set up MySQL pool
const pool = mysql.createPool({
  connectionLimit: 10,
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'ishkolarium'
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
      if (error) {
        connection.release();
        console.error('Error executing query:', error);
        return res.status(500).json({ message: 'Server error occurred' });
      }

      if (results.length > 0) {
        const user = results[0];
        
        const token = jwt.sign({ id: user.id, school_id: user.school_id }, secretKey, { expiresIn: '1h' });

        connection.query('UPDATE users SET token = ? WHERE id = ?', [token, user.id], (error, results) => {
          connection.release();

          if (error) {
            console.error('Error updating token:', error);
            return res.status(500).json({ message: 'Server error occurred' });
          }

          res.status(200).json({ message: `Welcome, ${user.first_name} ${user.last_name}`, token: token });
        });
      } else {
        connection.release();
        res.status(401).json({ message: 'Invalid school ID or password' });
      }
    });
  });
};
