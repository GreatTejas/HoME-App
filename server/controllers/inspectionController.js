const { Inspection, InspectionStudent, InspectionMedia, Room } = require('../models');
const { createUploadSignature } = require('../config/cloudinary');

function parseJson(value, fieldName) {
  if (typeof value !== 'string') return value;
  try { return JSON.parse(value); } catch (_) { const error = new Error(`${fieldName} must be valid JSON`); error.statusCode = 400; throw error; }
}

function validateInspection(body) {
  const students = parseJson(body.students, 'students');
  const conditions = parseJson(body.conditions, 'conditions');
  if (!Array.isArray(students) || students.length === 0 || students.some((name) => typeof name !== 'string' || !name.trim())) {
    const error = new Error('At least one student name is required'); error.statusCode = 400; throw error;
  }
  if (!conditions || typeof conditions !== 'object' || Array.isArray(conditions)) {
    const error = new Error('conditions must be an object'); error.statusCode = 400; throw error;
  }
  if (!body.studentSignature || !body.securitySignature) {
    const error = new Error('Student and security signatures are required'); error.statusCode = 400; throw error;
  }
  const media = parseJson(body.media || '[]', 'media');
  if (!Array.isArray(media) || media.some((asset) => !asset || !['photo', 'video'].includes(asset.mediaType) || !asset.secureUrl || !asset.publicId)) {
    const error = new Error('media must contain Cloudinary photo/video records'); error.statusCode = 400; throw error;
  }
  if (media.filter((asset) => asset.mediaType === 'photo').length > 10 || media.filter((asset) => asset.mediaType === 'video').length > 1) {
    const error = new Error('An inspection supports up to 10 photos and 1 video'); error.statusCode = 400; throw error;
  }
  return { students: students.map((name) => name.trim()), conditions, media };
}

async function getRoomInspections(req, res) {
  const room = await Room.findByPk(req.params.roomId);
  if (!room) return res.status(404).json({ message: 'Room not found' });
  const inspections = await Inspection.findAll({
    where: { roomId: room.id },
    include: [{ model: InspectionStudent, as: 'students' }, { model: InspectionMedia, as: 'media' }],
    order: [['inspectionDate', 'DESC'], ['id', 'DESC']],
  });
  return res.json(inspections);
}

async function getInspectionById(req, res) {
  const inspection = await Inspection.findByPk(req.params.id, { include: [{ model: Room, as: 'room' }, { model: InspectionStudent, as: 'students' }, { model: InspectionMedia, as: 'media' }] });
  if (!inspection) return res.status(404).json({ message: 'Inspection not found' });
  return res.json(inspection);
}

async function createInspection(req, res) {
  const room = await Room.findByPk(req.body.roomId);
  if (!room) return res.status(404).json({ message: 'Room not found' });
  const { students, conditions, media } = validateInspection(req.body);
  const inspection = await Inspection.sequelize.transaction(async (transaction) => {
      const created = await Inspection.create({ roomId: room.id, inspectionType: req.body.inspectionType || 'check_in', inspectionDate: req.body.inspectionDate || new Date().toISOString().slice(0, 10), conditions, comments: req.body.comments || null, studentSignature: req.body.studentSignature, securitySignature: req.body.securitySignature, createdBy: req.user.id }, { transaction });
      await InspectionStudent.bulkCreate(students.map((name) => ({ inspectionId: created.id, name })), { transaction });
      if (media.length) await InspectionMedia.bulkCreate(media.map((asset) => ({ inspectionId: created.id, mediaType: asset.mediaType, secureUrl: asset.secureUrl, publicId: asset.publicId, mimeType: asset.mimeType || null })), { transaction });
      return created;
  });
  return res.status(201).json(await Inspection.findByPk(inspection.id, { include: [{ model: InspectionStudent, as: 'students' }, { model: InspectionMedia, as: 'media' }] }));
}

function getUploadSignature(req, res) {
  return res.json(createUploadSignature(req.body.resourceType));
}

module.exports = { getRoomInspections, getInspectionById, createInspection, getUploadSignature };
