const express = require('express');
const storageController = require('../controllers/storageController');
const authMiddleware = require('../middleware/authMiddleware');
const roleMiddleware = require('../middleware/roleMiddleware');
const asyncHandler = require('../middleware/asyncHandler');

const router = express.Router();

router.use(authMiddleware);

router.get('/', asyncHandler(storageController.getAllStorageItems));
router.get('/:id', asyncHandler(storageController.getStorageItemById));
router.post('/', roleMiddleware('admin', 'home office', 'warden', 'security', 'secratery'), asyncHandler(storageController.createStorageItem));
router.put('/:id', roleMiddleware('admin', 'home office', 'warden', 'security', 'secratery'), asyncHandler(storageController.updateStorageItem));
router.delete('/:id', roleMiddleware('admin', 'home office', 'warden'), asyncHandler(storageController.deleteStorageItem));

module.exports = router;
