const express = require('express');
const router = express.Router();
const professorController = require('../controllers/professor_controller');
const { verifyToken }  = require('../middleware/auth');

//professor routes
router.post('/prof/createPost', verifyToken, professorController.createPost);
router.get('/prof/profile/:token', verifyToken, professorController.getUserProfile);
router.get('/prof/getPosts/:school_id', verifyToken, professorController.getUserPosts);
router.get('/prof/getSchedule/:prof_id', verifyToken, professorController.getProfSchedule);
router.put('/prof/updatePost/:id', verifyToken, professorController.updatePost);


module.exports = router;