const express = require('express');
const router = express.Router();
const userController = require('../controllers/user_controller');
const professorController = require('../controllers/professor_controller');

//user routes
//For Student Home Page
router.get('/user/getAnnouncements', userController.getAnnouncements);
router.get('/user/getLatestAnnouncement', userController.getLatestAnnouncement);
router.get('/user/getPosts/:status', userController.getPosts);
router.get('/user/getSchedule/:school_id', userController.getUserSchedule);
router.get('/user/getDTR/:school_id', userController.getUserDTR);
router.get('/user/getTotalHours/:token', userController.getUserTotalHours);


//For Student Profile Page
router.get('/user/profile/:token', userController.getUserProfile);
router.put('/user/updatePassword/:token', userController.updatePassword);


module.exports = router;