const express = require('express');
const router = express.Router();
const loginController = require('../controllers/login_controller');

//Login
router.post('/login', loginController.login);

module.exports = router;