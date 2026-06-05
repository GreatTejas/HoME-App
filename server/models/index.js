const sequelize = require('../config/db');
const User = require('./User');
const Hostel = require('./Hostel');
const Room = require('./Room');
const StorageItem = require('./StorageItem');

User.belongsTo(User, {
  foreignKey: 'createdBy',
  as: 'creator',
});
User.hasMany(User, {
  foreignKey: 'createdBy',
  as: 'createdUsers',
});

User.hasMany(Hostel, {
  foreignKey: 'wardenId',
  as: 'hostels',
});
Hostel.belongsTo(User, {
  foreignKey: 'wardenId',
  as: 'warden',
});
Hostel.belongsTo(User, {
  foreignKey: 'createdBy',
  as: 'creator',
});
User.hasMany(Hostel, {
  foreignKey: 'createdBy',
  as: 'createdHostels',
});

Hostel.hasMany(Room, {
  foreignKey: 'hostelId',
  as: 'rooms',
});
Room.belongsTo(Hostel, {
  foreignKey: 'hostelId',
  as: 'hostel',
});
Room.belongsTo(User, {
  foreignKey: 'createdBy',
  as: 'creator',
});
User.hasMany(Room, {
  foreignKey: 'createdBy',
  as: 'createdRooms',
});

Room.hasMany(StorageItem, {
  foreignKey: 'roomId',
  as: 'storageItems',
});
StorageItem.belongsTo(Room, {
  foreignKey: 'roomId',
  as: 'room',
});

User.hasMany(StorageItem, {
  foreignKey: 'takenByUserId',
  as: 'takenStorageItems',
});
StorageItem.belongsTo(User, {
  foreignKey: 'takenByUserId',
  as: 'takenBy',
});

module.exports = {
  sequelize,
  User,
  Hostel,
  Room,
  StorageItem,
};
