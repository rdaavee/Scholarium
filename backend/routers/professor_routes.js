const express = require('express');
const router = express.Router();
const professorController = require('../controllers/professor_controller');
const { verifyToken }  = require('../middleware/auth');

//professor routes
router.post('/createPost', verifyToken, professorController.createNotification);
router.post('/createDTR', verifyToken, professorController.createDTR);

router.get('/profile/:token', verifyToken, professorController.getUserProfile);
router.get('/getPosts/:school_id', verifyToken, professorController.getUserPosts);
router.get('/getSchedule/:month', verifyToken, professorController.getProfSchedule);
router.get('/getTodaySchedule/:prof_id', verifyToken, professorController.getProfTodaySchedule);

router.put('/updatePost/:id', verifyToken, professorController.updatePost);
router.put('/updateStudentsSchedule/:id', verifyToken, professorController.updateStudentsSchedules);


module.exports = router;