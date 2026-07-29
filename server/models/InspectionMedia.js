const { DataTypes } = require('sequelize');
const sequelize = require('../config/db');

const InspectionMedia = sequelize.define('InspectionMedia', {
  id: { type: DataTypes.INTEGER, autoIncrement: true, primaryKey: true },
  inspectionId: { type: DataTypes.INTEGER, allowNull: false, field: 'inspection_id' },
  mediaType: { type: DataTypes.ENUM('photo', 'video'), allowNull: false, field: 'media_type' },
  secureUrl: { type: DataTypes.STRING(2048), allowNull: false, field: 'secure_url' },
  publicId: { type: DataTypes.STRING(255), allowNull: false, field: 'public_id' },
  mimeType: { type: DataTypes.STRING(100), field: 'mime_type' },
  createdAt: { type: DataTypes.DATE, field: 'created_at', defaultValue: DataTypes.NOW },
}, { tableName: 'inspection_media', updatedAt: false });

module.exports = InspectionMedia;
