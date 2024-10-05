const express = require('express');
const router = express.Router();
const authenticationController = require("../controllers/authentication_controller");
const { verifyToken }  = require('../middleware/auth');

router.post('/forgotPassword', authenticationController.forgotPassword);
router.post('/resetPassword', authenticationController.resetPassword);
router.post('/login', authenticationController.login);

router.post('/postMessage', authenticationController.postMessage);
router.get('/getMessages/:sender/:receiver', authenticationController.getMessages);
router.get('/chatHistory', verifyToken, authenticationController.getReceiversBySender);

module.exports = router;
