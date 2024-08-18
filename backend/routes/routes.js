const express = require('express');
const router = express.Router();
const userController = require('../controllers/user_controller');

//user routes
router.get('/user/:id', userController.getUser);
router.get('/users', userController.getAllUsers);

//admin routes


module.exports = router;