//imports
const express = require('express');
const bodyParser = require('body-parser');
const authRoutes = require('./routers/auth_routes'); 
const userRoutes = require('./routers/user_routes'); 
const adminRoutes = require('./routers/admin_routes'); 

const app = express();
const port = process.env.PORT || 3000;

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

// Use routes
app.use('/api', authRoutes);
app.use('/api', userRoutes);
app.use('/api', adminRoutes);


app.listen(port, () => console.log(`Listening on port ${port}`));