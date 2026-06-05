const express = require('express');
const roomController = require('../controllers/roomController');
const authMiddleware = require('../middleware/authMiddleware');
const roleMiddleware = require('../middleware/roleMiddleware');
const asyncHandler = require('../middleware/asyncHandler');

const router = express.Router();

router.use(authMiddleware);

router.get('/', asyncHandler(roomController.getAllRooms));
router.get('/:id', asyncHandler(roomController.getRoomById));
router.post('/', roleMiddleware('admin', 'home office', 'warden'), asyncHandler(roomController.createRoom));
router.put('/:id', roleMiddleware('admin', 'home office', 'warden'), asyncHandler(roomController.updateRoom));
router.delete('/:id', roleMiddleware('admin', 'home office'), asyncHandler(roomController.deleteRoom));

module.exports = router;
