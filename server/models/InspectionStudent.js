const { DataTypes } = require('sequelize');
const sequelize = require('../config/db');

const InspectionStudent = sequelize.define('InspectionStudent', {
  id: { type: DataTypes.INTEGER, autoIncrement: true, primaryKey: true },
  inspectionId: { type: DataTypes.INTEGER, allowNull: false, field: 'inspection_id' },
  name: { type: DataTypes.STRING(150), allowNull: false },
}, { tableName: 'inspection_students', updatedAt: false });

module.exports = InspectionStudent;
