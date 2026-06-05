const { DataTypes } = require('sequelize');
const sequelize = require('../config/db');

const User = sequelize.define(
  'User',
  {
    id: {
      type: DataTypes.STRING(128),
      primaryKey: true,
    },
    name: {
      type: DataTypes.STRING(100),
      allowNull: false,
    },
    email: {
      type: DataTypes.STRING(100),
      allowNull: false,
      unique: true,
    },
    phoneNumber: {
      type: DataTypes.STRING(20),
      field: 'phone_number',
    },
    role: {
      type: DataTypes.ENUM('admin', 'warden', 'security', 'secratery', 'home office'),
      allowNull: false,
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
    tableName: 'users',
  }
);

module.exports = User;
