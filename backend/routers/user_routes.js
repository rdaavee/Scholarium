const express = require('express');
const router = express.Router();
const userController = require('../controllers/user_controller');
const professorController = require('../controllers/professor_controller');
const loginController = require('../controllers/login_controller');
const uploadcontroller = require('../controllers/upload_controller');


//Login
router.post('/login', loginController.login);


//user routes
router.get('/user/getAnnouncements', userController.getAnnouncements);
router.get('/user/getLatestAnnouncement', userController.getLatestAnnouncement);
router.get('/user/getPosts/:status', userController.getPosts);
router.get('/user/profile/:token', userController.getUserProfile);
router.post('/user/profile/upload/:token', uploadcontroller.uploadImage);
router.get('/user/getSchedule/:school_id', userController.getUserSchedule);
router.get('/user/getDTR/:school_id', userController.getUserDTR);
router.get('/user/getTotalHours/:token', userController.getUserTotalHours);


//professor routes
router.post('/prof/createPost', professorController.createPost);
router.get('/prof/profile/:token', professorController.getUserProfile);
router.get('/prof/getPosts/:school_id', professorController.getUserPosts);
router.get('/prof/getSchedule/:prof_id', professorController.getProfSchedule);
router.put('/prof/updatePost/:id', professorController.updatePost);


module.exports = router;