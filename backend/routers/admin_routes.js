const express = require('express');
const router = express.Router();
const adminController = require('../controllers/admin_controller');
const { verifyToken }  = require('../middleware/auth');

//User control
router.get('/listUsers', verifyToken, adminController.getAllUsers);
router.get('/getYearSched', verifyToken, adminController.getCurrentYearSchedules);
router.post('/insertUser', verifyToken, adminController.createUser);
router.put('/updateUser/:school_id',verifyToken, adminController.updateUser);
router.delete('/deleteUser/:school_id',verifyToken, adminController.deleteUser);

//Announcements controls
router.get('/getAllAnnouncements', verifyToken, adminController.getAllAnnouncements);
router.post('/createAnnouncement', verifyToken, adminController.createAnnouncement);
router.put('/updateAnnouncement',verifyToken, adminController.updateAnnouncement);
router.delete('/deleteAnnouncement',verifyToken, adminController.deleteAnnouncement);


module.exports = router;