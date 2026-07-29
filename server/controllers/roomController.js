const { Room } = require('../models');

async function getAllRooms(req, res) {
  if (!req.query.hostelId) return res.status(400).json({ message: 'hostelId is required' });
  const rooms = await Room.findAll({
    where: { hostelId: req.query.hostelId },
    attributes: ['id', 'roomNumber'],
    order: [['roomNumber', 'ASC']],
  });
  return res.json(rooms);
}

module.exports = { getAllRooms };
