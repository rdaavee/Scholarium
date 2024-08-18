//imports
const express = require('express');
const bodyParser = require('body-parser');
const authRoutes = require('./routes/auth'); 
const userRoutes = require('./routes/routes'); 
const adminRoutes = require('./routes/admin'); 

const app = express();
const port = process.env.PORT || 3000;

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

// Use routes
app.use('/', authRoutes);
app.use('/', userRoutes);
app.use('/', adminRoutes);


app.listen(port, () => console.log(`Listening on port ${port}`));