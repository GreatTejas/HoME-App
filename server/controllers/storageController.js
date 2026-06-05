const { Room, StorageItem, User } = require('../models');

async function getAllStorageItems(req, res) {
  const where = req.query.roomId ? { roomId: req.query.roomId } : undefined;
  const storageItems = await StorageItem.findAll({
    where,
    include: [
      { model: Room, as: 'room' },
      { model: User, as: 'takenBy', attributes: ['id', 'name', 'email', 'role'] },
    ],
    order: [['takenAt', 'DESC']],
  });

  return res.json(storageItems);
}

async function getStorageItemById(req, res) {
  const storageItem = await StorageItem.findByPk(req.params.id, {
    include: [
      { model: Room, as: 'room' },
      { model: User, as: 'takenBy', attributes: ['id', 'name', 'email', 'role'] },
    ],
  });

  if (!storageItem) {
    return res.status(404).json({ message: 'Storage item not found' });
  }

  return res.json(storageItem);
}

async function createStorageItem(req, res) {
  const payload = {
    ...req.body,
    takenByUserId: req.body.takenByUserId || req.user?.id,
  };
  const storageItem = await StorageItem.create(payload);
  return res.status(201).json(storageItem);
}

async function updateStorageItem(req, res) {
  const storageItem = await StorageItem.findByPk(req.params.id);

  if (!storageItem) {
    return res.status(404).json({ message: 'Storage item not found' });
  }

  await storageItem.update(req.body);
  return res.json(storageItem);
}

async function deleteStorageItem(req, res) {
  const deleted = await StorageItem.destroy({ where: { id: req.params.id } });

  if (!deleted) {
    return res.status(404).json({ message: 'Storage item not found' });
  }

  return res.status(204).send();
}

module.exports = {
  getAllStorageItems,
  getStorageItemById,
  createStorageItem,
  updateStorageItem,
  deleteStorageItem,
};
