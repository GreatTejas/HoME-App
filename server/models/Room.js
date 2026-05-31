const { DataTypes } = require('sequelize');
const sequelize = require('../config/db');

const Room = sequelize.define(
  'Room',
  {
    id: {
      type: DataTypes.INTEGER,
      autoIncrement: true,
      primaryKey: true,
    },
    hostelId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      field: 'hostel_id',
      references: {
        model: 'hostels',
        key: 'id',
      },
    },
    roomNumber: {
      type: DataTypes.STRING(20),
      allowNull: false,
      field: 'room_number',
    },
    roomType: {
      type: DataTypes.ENUM('common', 'standard', 'study', 'other'),
      field: 'room_type',
    },
    capacity: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: 1,
    },
    occupancyCount: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: 0,
      field: 'occupancy_count',
    },
    createdBy: {
      type: DataTypes.STRING(128),
      field: 'created_by',
      references: {
        model: 'users',
        key: 'id',
      },
    },
    createdAt: {
      type: DataTypes.DATE,
      field: 'created_at',
      defaultValue: DataTypes.NOW,
    },
  },
  {
    tableName: 'rooms',
    indexes: [
      {
        unique: true,
        fields: ['hostel_id', 'room_number'],
      },
    ],
  }
);

module.exports = Room;
