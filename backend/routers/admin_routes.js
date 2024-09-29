const express = require('express');
const router = express.Router();
const adminController = require('../controllers/admin_controller');
const { verifyToken }  = require('../middleware/auth');

//User control
router.get('/admin/listUsers', verifyToken, adminController.getAllUsers);
router.post('/admin/insertUser', verifyToken, adminController.createUser);
router.put('/admin/updateUser/:school_id',verifyToken, adminController.updateUser);
router.delete('/admin/deleteUser/:school_id',verifyToken, adminController.deleteUser);

//Announcements controls
router.post('/admin/announce', verifyToken, adminController.createAnnounce);
router.post('/admin/updateAnnounce/:id',verifyToken, adminController.updateAnnounce);
router.post('/admin/deleteAnnounce/:id',verifyToken, adminController.deleteAnnounce);


module.exports = router;