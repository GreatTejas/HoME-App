const express = require('express');
const hostelController = require('../controllers/hostelController');
const authMiddleware = require('../middleware/authMiddleware');
const asyncHandler = require('../middleware/asyncHandler');

const router = express.Router();
router.use(authMiddleware);
router.get('/code/:hostelCode', asyncHandler(hostelController.getHostelByCode));

module.exports = router;
