const express = require("express");
const router = express.Router();
const userController = require("../controllers/user_controller");
const uploadcontroller = require("../controllers/upload_controller");
const { verifyToken }  = require('../middleware/auth');

//user routes
//--------------------------------FOR HOME PAGE------------------------------------------------------------------

router.get("/getUpcomingSchedule",verifyToken, userController.getUserUpcomingSchedule);
router.get("/getAnnouncements",verifyToken, userController.getAnnouncements);
router.get("/getLatestAnnouncement",verifyToken, userController.getLatestAnnouncement);
router.get("/getPosts/:status",verifyToken, userController.getPosts);
router.get("/getTotalHours",verifyToken, userController.getUserTotalHours);
router.get("/getDTR",verifyToken, userController.getUserDTR);

//--------------------------------FOR SCHEDULE PAGE--------------------------------------------------------------

router.get("/getSchedule/:month", verifyToken, userController.getUserSchedule);

//--------------------------------FOR NOTIFICATION PAGE----------------------------------------------------------
router.get("/getNotifications", verifyToken, userController.getUserNotifications);

//--------------------------------FOR PROFILE PAGE---------------------------------------------------------------
router.get("/profile",verifyToken, userController.getUserProfile);
router.put("/updatePassword",verifyToken, userController.updatePassword);
router.post("/profile/upload",verifyToken, uploadcontroller.uploadImage);

module.exports = router;
