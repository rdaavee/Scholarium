//imports
require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const userRoutes = require('./routers/user_routes'); 
const adminRoutes = require('./routers/admin_routes'); 
const path = require('path');


const app = express();
const PORT = process.env.PORT || 3000;

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

// Use routes
app.use('/api', userRoutes);
app.use('/api', adminRoutes);
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
