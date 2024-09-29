const express = require('express');
const router = express.Router();
const authenticationController = require("../controllers/authentication_controller");

router.post('/forgotPassword', authenticationController.forgotPassword);
router.post('/resetPassword', authenticationController.resetPassword);
router.post('/login', authenticationController.login);

module.exports = router;
