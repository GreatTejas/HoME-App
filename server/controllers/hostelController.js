const { Hostel, Room, User } = require('../models');

async function getAllHostels(req, res) {
  const hostels = await Hostel.findAll({
    include: [
      { model: User, as: 'warden', attributes: ['id', 'name', 'email', 'role'] },
      { model: Room, as: 'rooms' },
    ],
    order: [['id', 'ASC']],
  });

  return res.json(hostels);
}

async function getHostelById(req, res) {
  const hostel = await Hostel.findByPk(req.params.id, {
    include: [
      { model: User, as: 'warden', attributes: ['id', 'name', 'email', 'role'] },
      { model: Room, as: 'rooms' },
    ],
  });

  if (!hostel) {
    return res.status(404).json({ message: 'Hostel not found' });
  }

  return res.json(hostel);
}

async function createHostel(req, res) {
  const hostel = await Hostel.create({
    ...req.body,
    createdBy: req.body.createdBy || req.user?.id,
  });
  return res.status(201).json(hostel);
}

async function updateHostel(req, res) {
  const hostel = await Hostel.findByPk(req.params.id);

  if (!hostel) {
    return res.status(404).json({ message: 'Hostel not found' });
  }

  await hostel.update(req.body);
  return res.json(hostel);
}

async function deleteHostel(req, res) {
  const deleted = await Hostel.destroy({ where: { id: req.params.id } });

  if (!deleted) {
    return res.status(404).json({ message: 'Hostel not found' });
  }

  return res.status(204).send();
}

module.exports = {
  getAllHostels,
  getHostelById,
  createHostel,
  updateHostel,
  deleteHostel,
};
