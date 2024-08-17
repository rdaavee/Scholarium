//imports
const express = require('express');
const bodyParser = require('body-parser');
const mysql = require('mysql');

//inialize the backend
const app = express();
const port = process.env.port || 3000;

app.use(bodyParser.urlencoded({ extended: false}));
app.use(bodyParser.json());

//MySQL setup
const pool = mysql.createPool({
    connectionLimit : 10,
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'isHKolarium'
});

//controller or REST API
app.get('/', (req, res) => {
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
});

app.get('/:id', (req, res) => {
    pool.getConnection((error, connection) => {
        if (error) throw error;
        console.log(`connected as id ${connection.threadId}`);

        connection.query('SELECT * from users WHERE id = ?', [req.params.id], (error, rows) => {
            connection.release();

            if (!error) {
                res.status(200).json(rows);
            } else {
                console.log(error)
                res.status(500).json(error);
            };
        });
    });
});

app.delete('/:id', (req, res) => {
    pool.getConnection((error, connection) => {
        if (error) throw error;
        console.log(`connected as id ${connection.threadId}`);

        connection.query('DELETE * from users WHERE id = ?', [req.params.id], (error, rows) => {
            connection.release();

            if (!error) {
                res.status(200).json({ message: `Record of ID # ${[req.params.id]} has been deleted.`});
            } else {
                console.log(error);
                res.status(500).json({ message: error});
            };
        });
    });
});

app.post('/insert', (req, res) => {
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
});

app.put('/update', (req, res) => {
    pool.getConnection((error, connection) => {
        if (error) throw error;
        console.log(`connected as id ${connection.threadId}`);

        const {id, school_id, email, first_name, middle_name, last_name, role, status} = req.body;

        connection.query('UPDATE users SET first_name = ?, middle_name = ?, last_name = ? WHERE id = ?',[id, first_name, middle_name, last_name] , (error, rows) => {
            connection.release();

            if (!error) {
                res.status(200).json({ message: `Record of ${last_name}, ${first_name} ${middle_name} has been updated.`});
            } else {
                console.log(error);
                res.status(500).json({ message: error});
            };
        });
    });
});

app.post('/api/login', (req, res) => {
    try {
        pool.getConnection((error, connection) => {
            if (error) {throw error;}
            console.log(`Connected as id ${connection.threadId}`);

            const { school_id, password } = req.body;

            connection.query('SELECT * FROM users WHERE school_id = ? AND password = ?', [school_id, password], (error, results) => {
                connection.release();

                if (error) {throw error;}

                if (results.length > 0) {
                    const user = results[0];
                    res.status(200).json({ message: `Welcome, ${user.first_name} ${user.last_name}` });
                } else {
                    res.status(401).json({ message: 'Invalid school ID or password' });
                }
            });
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error occurred' });
    }
});


//listen on env port
app.listen(port, () => console.log( `Listen on port ${port}`));