const express = require('express');
const router = express.Router();
const userController = require('../controllers/user_controller');

//user routes
router.get('/user/getAnnouncements', userController.getAnnouncements);


//only put routes with id
router.get('/user/:school_id', userController.getUserProfile);
router.get('/user/getSchedule/:school_id', userController.getUserSchedule);
router.get('/user/getDTR/:school_id', userController.getUserDTR);




module.exports = router;