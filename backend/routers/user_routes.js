const express = require('express');
const router = express.Router();
const userController = require('../controllers/user_controller');
const uploadcontroller = require('../controllers/upload_controller');

//user routes
router.get('/user/getAnnouncements', userController.getAnnouncements);
router.get('/user/getLatestAnnouncement', userController.getLatestAnnouncement);
router.get('/user/getPosts/:status', userController.getPosts);
router.get('/user/profile/:token', userController.getUserProfile);
router.get('/user/getSchedule/:school_id', userController.getUserSchedule);
router.get('/user/getDTR/:token', userController.getUserDTR);
router.get('/user/getTotalHours/:token', userController.getUserTotalHours);

router.put('/user/updatePassword/:token', userController.updatePassword);

router.post('/user/profile/upload/:token', uploadcontroller.uploadImage);


module.exports = router;