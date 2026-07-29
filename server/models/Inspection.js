const { DataTypes } = require('sequelize');
const sequelize = require('../config/db');

const Inspection = sequelize.define('Inspection', {
  id: { type: DataTypes.INTEGER, autoIncrement: true, primaryKey: true },
  roomId: { type: DataTypes.INTEGER, allowNull: false, field: 'room_id' },
  inspectionType: { type: DataTypes.ENUM('check_in', 'check_out'), allowNull: false, defaultValue: 'check_in', field: 'inspection_type' },
  inspectionDate: { type: DataTypes.DATEONLY, allowNull: false, field: 'inspection_date' },
  conditions: { type: DataTypes.JSON, allowNull: false },
  comments: { type: DataTypes.TEXT },
  studentSignature: { type: DataTypes.TEXT('long'), allowNull: false, field: 'student_signature' },
  securitySignature: { type: DataTypes.TEXT('long'), allowNull: false, field: 'security_signature' },
  createdBy: { type: DataTypes.STRING(128), allowNull: false, field: 'created_by' },
  createdAt: { type: DataTypes.DATE, field: 'created_at', defaultValue: DataTypes.NOW },
}, { tableName: 'inspections' });

module.exports = Inspection;
