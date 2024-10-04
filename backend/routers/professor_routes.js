const express = require('express');
const router = express.Router();
const professorController = require('../controllers/professor_controller');
const { verifyToken }  = require('../middleware/auth');

//professor routes
router.post('/createPost', verifyToken, professorController.createPost);
router.get('/profile/:token', verifyToken, professorController.getUserProfile);
router.get('/getPosts/:school_id', verifyToken, professorController.getUserPosts);
router.get('/getSchedule/:prof_id', verifyToken, professorController.getProfSchedule);
router.put('/updatePost/:id', verifyToken, professorController.updatePost);


module.exports = router;