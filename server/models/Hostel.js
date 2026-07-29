const { DataTypes } = require('sequelize');
const sequelize = require('../config/db');

const Hostel = sequelize.define(
  'Hostel',
  {
    id: {
      type: DataTypes.INTEGER,
      autoIncrement: true,
      primaryKey: true,
    },
    name: {
      type: DataTypes.STRING(100),
      allowNull: false,
    },
    hostelCode: {
      type: DataTypes.STRING(10),
      allowNull: false,
      field: 'hostel_code',
    },
    gender: {
      type: DataTypes.ENUM('male', 'female', 'co-ed'),
      allowNull: false,
    },
    wardenId: {
      type: DataTypes.STRING(128),
      field: 'warden_id',
      references: {
        model: 'users',
        key: 'id',
      },
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
    tableName: 'hostels',
  }
);

module.exports = Hostel;
