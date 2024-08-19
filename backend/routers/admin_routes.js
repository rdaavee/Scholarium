const express = require('express');
const router = express.Router();
const adminController = require('../controllers/admin_controller');

//User control
router.get('/admin/listUsers', adminController.getAllUsers);
router.post('/admin/insertUser', adminController.createUser);
router.put('/admin/updateUser/:school_id', adminController.updateUser);
router.delete('/admin/deleteUser/:school_id', adminController.deleteUser);

//Announcements controls
router.post('/admin/announce', adminController.createAnnounce);
router.post('/admin/updateAnnounce/:id', adminController.updateAnnounce);
router.post('/admin/deleteAnnounce/:id', adminController.deleteAnnounce);


module.exports = router;