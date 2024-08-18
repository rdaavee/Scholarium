const express = require('express');
const router = express.Router();
const adminController = require('../controllers/admin_controller');

//User control
router.get('/admin/users', adminController.getAllUsers);
router.post('/admin/insert', adminController.createUser);
router.delete('/admin/user/:id', adminController.deleteUser);

//Announcements controls
router.post('/admin/announce', adminController.createAnnounce);

module.exports = router;