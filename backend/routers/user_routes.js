const express = require("express");
const router = express.Router();
const userController = require("../controllers/user_controller");
const uploadcontroller = require("../controllers/upload_controller");
const { verifyToken }  = require('../middleware/auth');

//user routes
//--------------------------------FOR HOME PAGE-----------------------------------------------------------------

router.get("/user/getUpcomingSchedule",verifyToken, userController.getUserUpcomingSchedule);
router.get("/user/getAnnouncements",verifyToken, userController.getAnnouncements);
router.get("/user/getLatestAnnouncement",verifyToken, userController.getLatestAnnouncement);
router.get("/user/getPosts/:status",verifyToken, userController.getPosts);
router.get("/user/getTotalHours",verifyToken, userController.getUserTotalHours);
router.get("/user/getDTR",verifyToken, userController.getUserDTR);

//--------------------------------FOR SCHEDULE PAGE-----------------------------------------------------------------

router.get("/user/getSchedule/:month", verifyToken, userController.getUserSchedule);

//--------------------------------FOR NOTIFICATION PAGE-----------------------------------------------------------------
router.get("/user/getNotifications", verifyToken, userController.getUserNotifications);

//--------------------------------FOR PROFILE PAGE-----------------------------------------------------------------
router.get("/user/profile",verifyToken, userController.getUserProfile);
router.put("/user/updatePassword",verifyToken, userController.updatePassword);
router.post("/user/profile/upload",verifyToken, uploadcontroller.uploadImage);

module.exports = router;
