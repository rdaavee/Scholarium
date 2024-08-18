const mysql = require('mysql');
const pool = mysql.createPool({
  connectionLimit: 10,
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'ishkolarium'
});

exports.createUser = (req, res) => {
    pool.getConnection((error, connection) => {
        if (error) throw error;
        console.log(`connected as id ${connection.threadId}`);

        const params = req.body;

        connection.query('INSERT INTO users SET ?', params, (error, rows) => {
            connection.release();

            if (!error) {
                res.status(200).json({ message: `Record of ${[params.last_name, params.first_name, params.middle_name]} has been added.`});
            } else {
                console.log(error);
                res.status(500).json({ message: error});
            };
        });
    });
};

exports.deleteUser = (req, res) => {
    pool.getConnection((error, connection) => {
        if (error) {
            console.error('Error getting MySQL connection:', error);
            return res.status(500).json({ message: 'Server error occurred' });
        }
        console.log(`Connected as id ${connection.threadId}`);

        connection.query('DELETE FROM users WHERE id = ?', [req.params.id], (error, result) => {
            connection.release(); 

            if (error) {
                console.error('Error executing query:', error);
                return res.status(500).json({ message: 'Server error occurred' });
            }

            if (result.affectedRows > 0) {
                res.status(200).json({ message: `Record with ID # ${req.params.id} has been deleted.` });
            } else {
                res.status(404).json({ message: 'User not found' });
            }
        });
    });
};

exports.createAnnounce = (req, res) => {
    pool.getConnection((error, connection) => {
        if (error) throw error;
        console.log(`connected as id ${connection.threadId}`);

        const params = req.body;

        connection.query('INSERT INTO announcements SET ?', params, (error, rows) => {
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