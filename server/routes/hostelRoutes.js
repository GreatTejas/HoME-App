const express = require('express');
const hostelController = require('../controllers/hostelController');
const authMiddleware = require('../middleware/authMiddleware');
const roleMiddleware = require('../middleware/roleMiddleware');
const asyncHandler = require('../middleware/asyncHandler');

const router = express.Router();

router.use(authMiddleware);

router.get('/', asyncHandler(hostelController.getAllHostels));
router.get('/:id', asyncHandler(hostelController.getHostelById));
router.post('/', roleMiddleware('admin', 'home office'), asyncHandler(hostelController.createHostel));
router.put('/:id', roleMiddleware('admin', 'home office', 'warden'), asyncHandler(hostelController.updateHostel));
router.delete('/:id', roleMiddleware('admin'), asyncHandler(hostelController.deleteHostel));

module.exports = router;
