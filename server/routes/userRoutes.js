const express = require('express');
const userController = require('../controllers/userController');
const authMiddleware = require('../middleware/authMiddleware');
const roleMiddleware = require('../middleware/roleMiddleware');
const asyncHandler = require('../middleware/asyncHandler');

const router = express.Router();

router.use(authMiddleware);

router.get('/me', asyncHandler(userController.getCurrentUser));
router.get('/', roleMiddleware('admin', 'home office'), asyncHandler(userController.getAllUsers));
router.get('/:id', roleMiddleware('admin', 'home office'), asyncHandler(userController.getUserById));
router.post('/', roleMiddleware('admin'), asyncHandler(userController.createUser));
router.put('/:id', roleMiddleware('admin'), asyncHandler(userController.updateUser));
router.delete('/:id', roleMiddleware('admin'), asyncHandler(userController.deleteUser));

module.exports = router;
