const express = require('express');
const router = express.Router();
const userController = require('../controllers/user_controller');
const profController = require('../controllers/professor_controller');

//user routes
router.get('/user/getAnnouncements', userController.getAnnouncements);
router.get('/user/getPosts/:status', userController.getPosts);

//only put routes with id
router.get('/user/:school_id', userController.getUserProfile);
router.get('/user/getSchedule/:school_id', userController.getUserSchedule);
router.get('/user/getDTR/:school_id', userController.getUserDTR);

//professor routes
router.post('/prof/post', profController.createPost);

//professor routes that require id
router.get('/prof/:school_id', profController.getUserProfile);
router.get('/prof/getPosts/:school_id', profController.getUserPosts);

module.exports = router;