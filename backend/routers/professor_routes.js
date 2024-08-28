const express = require('express');
const router = express.Router();
const professorController = require('../controllers/professor_controller');

//professor routes
router.post('/prof/createPost', professorController.createPost);
router.get('/prof/profile/:token', professorController.getUserProfile);
router.get('/prof/getPosts/:school_id', professorController.getUserPosts);
router.get('/prof/getSchedule/:prof_id', professorController.getProfSchedule);
router.put('/prof/updatePost/:id', professorController.updatePost);


module.exports = router;