const express = require("express");
const router = express.Router();
const userController = require("../controllers/user_controller");
const uploadcontroller = require("../controllers/upload_controller");

//user routes
//--------------------------------FOR HOME PAGE-----------------------------------------------------------------

router.get("/user/getUpcomingSchedule/:token", userController.getUserUpcomingSchedule);
router.get("/user/getAnnouncements", userController.getAnnouncements);
router.get("/user/getLatestAnnouncement", userController.getLatestAnnouncement);
router.get("/user/getPosts/:status", userController.getPosts);
router.get("/user/getTotalHours/:token", userController.getUserTotalHours);
router.get("/user/getDTR/:token", userController.getUserDTR);

//--------------------------------FOR SCHEDULE PAGE-----------------------------------------------------------------

router.get("/user/getSchedule/:token", userController.getUserSchedule);

//--------------------------------FOR NOTIFICATION PAGE-----------------------------------------------------------------
router.get("/user/getNotifications/:token", userController.getUserNotifications);

//--------------------------------FOR PROFILE PAGE-----------------------------------------------------------------
router.get("/user/profile/:token", userController.getUserProfile);
router.put("/user/updatePassword/:token", userController.updatePassword);
router.post("/user/profile/upload/:token", uploadcontroller.uploadImage);

module.exports = router;
