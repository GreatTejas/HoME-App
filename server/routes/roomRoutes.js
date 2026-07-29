const express = require('express');
const roomController = require('../controllers/roomController');
const authMiddleware = require('../middleware/authMiddleware');
const asyncHandler = require('../middleware/asyncHandler');

const router = express.Router();
router.use(authMiddleware);
router.get('/', asyncHandler(roomController.getAllRooms));

module.exports = router;
