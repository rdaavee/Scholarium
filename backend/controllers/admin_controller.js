const db = require('../config/db');

//Create a user
exports.createUser = (req, res) => {
    db.getConnection((error, connection) => {
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

//Update user
exports.updateUser = (req, res) => {
    db.getConnection((error, connection) => {
        if (error) {
            console.error('Error getting connection:', error);
            return res.status(500).json({ message: 'Error connecting to the database' });
        }
        
        console.log(`Connected as id ${connection.threadId}`);

        const school_id = req.params.school_id;
        const params = req.body;  

        console.log('ID from params:', school_id);
        console.log('Params from body:', params);

        if (!school_id) {
            connection.release();
            return res.status(400).json({ message: 'School ID is required as a URL parameter' });
        }
        connection.query('UPDATE users SET ? WHERE school_id = ?', [params, school_id], (error, results) => {
            connection.release();
            if (error) {
                console.error('Error executing query:', error);
                return res.status(500).json({ message: 'Database query error' });
            }
            console.log('Query Results:', results);
            if (results.affectedRows === 0) {
                return res.status(404).json({ message: `No record found with ID ${school_id}.` });
            }
            res.status(200).json({ 
                message: `Record of ${[params.last_name, params.first_name, params.middle_name]} has been updated.` 
            });
        });
    });
};



//Delete a user
exports.deleteUser = (req, res) => {
    db.getConnection((error, connection) => {
        if (error) {
            console.error('Error getting MySQL connection:', error);
            return res.status(500).json({ message: 'Server error occurred' });
        }
        console.log(`Connected as id ${connection.threadId}`);

        connection.query('DELETE FROM users WHERE school_id = ?', [req.params.school_id], (error, result) => {
            connection.release(); 

            if (error) {
                console.error('Error executing query:', error);
                return res.status(500).json({ message: 'Server error occurred' });
            }

            if (result.affectedRows > 0) {
                res.status(200).json({ message: `Record with ID # ${req.params.school_id} has been deleted.` });
            } else {
                res.status(404).json({ message: 'User not found' });
            }
        });
    });
};

//List all users
exports.getAllUsers = (req, res) => {
    db.getConnection((error, connection) => {
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

//Create announcement
exports.createAnnounce = (req, res) => {
    db.getConnection((error, connection) => {
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

//Update announcement
exports.updateAnnounce = (req, res) => {
    db.getConnection((error, connection) => {
        if (error) throw error;
        console.log(`connected as id ${connection.threadId}`);

        const { id, ...params } = req.body;

        connection.query('UPDATE announcements SET ? WHERE id = ?', [params, id], (error, results) => {
            connection.release();

            if (!error) {
                if (results.affectedRows === 0) {
                    res.status(404).json({ message: `No record found with ID ${id}.` });
                } else {
                    res.status(200).json({ message: `Announcement with ID ${id} has been updated.` });
                }
            } else {
                console.log(error);
                res.status(500).json({ message: error });
            }
        });
    });
};


//Delete announcement
exports.deleteAnnounce = (req, res) => {
    db.getConnection((error, connection) => {
        if (error) {
            console.error('Error getting MySQL connection:', error);
            return res.status(500).json({ message: 'Server error occurred' });
        }
        console.log(`Connected as id ${connection.threadId}`);

        connection.query('DELETE FROM announcements WHERE id = ?', [req.params.id], (error, result) => {
            connection.release(); 

            if (error) {
                console.error('Error executing query:', error);
                return res.status(500).json({ message: 'Server error occurred' });
            }

            if (result.affectedRows > 0) {
                res.status(200).json({ message: `Announcement with ID # ${req.params.id} has been deleted.` });
            } else {
                res.status(404).json({ message: "Announcement doesn't Exist" });
            }
        });
    });
};
