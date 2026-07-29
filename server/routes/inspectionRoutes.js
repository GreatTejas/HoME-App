const express = require('express');
const inspectionController = require('../controllers/inspectionController');
const authMiddleware = require('../middleware/authMiddleware');
const roleMiddleware = require('../middleware/roleMiddleware');
const asyncHandler = require('../middleware/asyncHandler');

const router = express.Router();

router.use(authMiddleware);
router.get('/room/:roomId', asyncHandler(inspectionController.getRoomInspections));
router.get('/:id', asyncHandler(inspectionController.getInspectionById));
router.post('/upload-signature', roleMiddleware('admin', 'home office', 'warden', 'security', 'secratery'), asyncHandler(inspectionController.getUploadSignature));
router.post('/', roleMiddleware('admin', 'home office', 'warden', 'security', 'secratery'), asyncHandler(inspectionController.createInspection));

module.exports = router;
