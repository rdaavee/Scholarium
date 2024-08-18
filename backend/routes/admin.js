const express = require('express');
const router = express.Router();
const adminController = require('../controllers/admin_controller');

//User control
router.post('/insert', adminController.createUser);
router.delete('/user/:id', adminController.deleteUser);

//Announcements controls
router.post('/announce', adminController.createAnnounce);

module.exports = router;