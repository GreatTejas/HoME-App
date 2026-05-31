const { DataTypes } = require('sequelize');
const sequelize = require('../config/db');

const StorageItem = sequelize.define(
  'StorageItem',
  {
    id: {
      type: DataTypes.INTEGER,
      autoIncrement: true,
      primaryKey: true,
    },
    description: {
      type: DataTypes.TEXT,
    },
    photoUrl: {
      type: DataTypes.STRING(255),
      field: 'photo_url',
    },
    belongsTo: {
      type: DataTypes.STRING(10),
      field: 'belongs_to',
    },
    roomId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      field: 'room_id',
    },
    takenByUserId: {
      type: DataTypes.STRING(128),
      field: 'taken_by_user_id',
    },
    takenAt: {
      type: DataTypes.DATE,
      field: 'taken_at',
      defaultValue: DataTypes.NOW,
    },
  },
  {
    tableName: 'storage_items',
  }
);

module.exports = StorageItem;
