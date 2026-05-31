const { User } = require('../models');

async function getAllUsers(req, res) {
  const users = await User.findAll({ order: [['createdAt', 'DESC']] });
  return res.json(users);
}

async function getUserById(req, res) {
  const user = await User.findByPk(req.params.id);

  if (!user) {
    return res.status(404).json({ message: 'User not found' });
  }

  return res.json(user);
}

async function createUser(req, res) {
  const user = await User.create({
    ...req.body,
    createdBy: req.body.createdBy || req.user?.id,
  });
  return res.status(201).json(user);
}

async function updateUser(req, res) {
  const user = await User.findByPk(req.params.id);

  if (!user) {
    return res.status(404).json({ message: 'User not found' });
  }

  await user.update(req.body);
  return res.json(user);
}

async function deleteUser(req, res) {
  const deleted = await User.destroy({ where: { id: req.params.id } });

  if (!deleted) {
    return res.status(404).json({ message: 'User not found' });
  }

  return res.status(204).send();
}

async function getCurrentUser(req, res) {
  return res.json(req.user);
}

module.exports = {
  getAllUsers,
  getUserById,
  createUser,
  updateUser,
  deleteUser,
  getCurrentUser,
};
