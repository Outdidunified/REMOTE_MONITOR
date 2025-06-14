const express = require('express');
const router = express.Router();
// Import the controller function
const Controller = require('../controllers/IotDashboardController');
const verifyToken = require('../middlewares/IotDashboardMiddleware');

// Router register
router.post('/userRegister', Controller.userRegister);

// Router login
router.post('/userLogin', Controller.userLogin);

// Router forget password
router.post('/forgetPassword', Controller.forgetPassword);

// Router otp verify
router.post('/otpVerify', Controller.otpVerify);

// Router update password
router.post('/updatePassword', Controller.updatePassword);

// Router fetch user profile
router.post('/fetchUserProfile', verifyToken, Controller.fetchUserProfile);

// Router update user profile
router.post('/updateUserProfile', verifyToken, Controller.updateUserProfile);

// Router add device
router.post('/addDevice', verifyToken, Controller.addDevice);

// Router fetch device
router.get('/fetchDevice', verifyToken, Controller.fetchDevice);

// Router update device
router.post('/updateDevice', verifyToken, Controller.updateDevice);

// Router fetch device history
router.get('/fetchDeviceHistory', verifyToken, Controller.fetchDeviceHistory);

// Router fetch dashboard data
router.get('/fetchDashboardData', verifyToken, Controller.fetchDashboardData);
module.exports = router;
