const express = require('express');
const router = express.Router();
const adminController = require('../controllers/admin_controller');
const uploadController = require('../controllers/upload_controller');
const { verifyToken }  = require('../middleware/auth');

//User control
router.get('/listUsers', verifyToken, adminController.getAllUsers);
router.get('/getAllDTR', verifyToken, adminController.getAllDTR);
router.get('/getUserDutiesCompletedPerWeek', verifyToken, adminController.countCompletedSchedulesByDayThisWeek);
router.get('/getYearSched', verifyToken, adminController.getCurrentYearSchedules);
router.post('/insertUser', verifyToken, adminController.createUser);
router.post('/createSchedule', verifyToken, adminController.createScheduleAndNotification);
router.put('/deleteSchedule', verifyToken, adminController.deleteScheduleAndNotification);
router.put('/updateUser/:school_id',verifyToken, adminController.updateUser);
router.delete('/deleteUser/:school_id',verifyToken, adminController.deleteUser);
router.post('/createNotification', verifyToken, adminController.createNotification);
router.get('/schedule/:month', verifyToken, adminController.getScheduleAdmin);

//Announcements controls
router.get('/getAllAnnouncements', verifyToken, adminController.getAllAnnouncements);
router.post('/createAnnouncement', verifyToken, adminController.createAnnouncement);
router.post('/createEvent', verifyToken, uploadController.createEventWithImage);
router.put('/updateAnnouncement',verifyToken, adminController.updateAnnouncement);
router.delete('/deleteAnnouncement',verifyToken, adminController.deleteAnnouncement);


module.exports = router;