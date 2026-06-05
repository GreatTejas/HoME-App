const { Hostel, Room, StorageItem } = require('../models');

async function getAllRooms(req, res) {
  const where = req.query.hostelId ? { hostelId: req.query.hostelId } : undefined;
  const rooms = await Room.findAll({
    where,
    include: [
      { model: Hostel, as: 'hostel' },
      { model: StorageItem, as: 'storageItems' },
    ],
    order: [['roomNumber', 'ASC']],
  });

  return res.json(rooms);
}

async function getRoomById(req, res) {
  const room = await Room.findByPk(req.params.id, {
    include: [
      { model: Hostel, as: 'hostel' },
      { model: StorageItem, as: 'storageItems' },
    ],
  });

  if (!room) {
    return res.status(404).json({ message: 'Room not found' });
  }

  return res.json(room);
}

async function createRoom(req, res) {
  const room = await Room.create({
    ...req.body,
    createdBy: req.body.createdBy || req.user?.id,
  });
  await refreshHostelCounts(room.hostelId);
  return res.status(201).json(room);
}

async function updateRoom(req, res) {
  const room = await Room.findByPk(req.params.id);

  if (!room) {
    return res.status(404).json({ message: 'Room not found' });
  }

  const previousHostelId = room.hostelId;
  await room.update(req.body);
  await refreshHostelCounts(previousHostelId);

  if (previousHostelId !== room.hostelId) {
    await refreshHostelCounts(room.hostelId);
  }

  return res.json(room);
}

async function deleteRoom(req, res) {
  const room = await Room.findByPk(req.params.id);

  if (!room) {
    return res.status(404).json({ message: 'Room not found' });
  }

  const hostelId = room.hostelId;
  await room.destroy();
  await refreshHostelCounts(hostelId);
  return res.status(204).send();
}

async function refreshHostelCounts(hostelId) {
  if (!hostelId) return;

  const totalRooms = await Room.count({ where: { hostelId } });
  const totalStudents = await Room.sum('occupancyCount', { where: { hostelId } });

  await Hostel.update(
    {
      totalRooms,
      totalStudents: totalStudents || 0,
    },
    { where: { id: hostelId } }
  );
}

module.exports = {
  getAllRooms,
  getRoomById,
  createRoom,
  updateRoom,
  deleteRoom,
};
