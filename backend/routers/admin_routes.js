const express = require('express');
const router = express.Router();
const adminController = require('../controllers/admin_controller');
const { verifyToken }  = require('../middleware/auth');

//User control
router.get('/admin/listUsers', verifyToken, adminController.getAllUsers);
router.get('/admin/getYearSched', verifyToken, adminController.getCurrentYearSchedules);
router.post('/admin/insertUser', verifyToken, adminController.createUser);
router.put('/admin/updateUser/:school_id',verifyToken, adminController.updateUser);
router.delete('/admin/deleteUser/:school_id',verifyToken, adminController.deleteUser);

//Announcements controls
router.get('/admin/getAllAnnouncements', verifyToken, adminController.getAllAnnouncements);
router.post('/admin/createAnnouncement', verifyToken, adminController.createAnnouncement);
router.put('/admin/updateAnnouncement',verifyToken, adminController.updateAnnouncement);
router.delete('/admin/deleteAnnouncement',verifyToken, adminController.deleteAnnouncement);


module.exports = router;