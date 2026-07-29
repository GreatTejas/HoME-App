const sequelize = require('../config/db');
const User = require('./User');
const Hostel = require('./Hostel');
const Room = require('./Room');
const Inspection = require('./Inspection');
const InspectionStudent = require('./InspectionStudent');
const InspectionMedia = require('./InspectionMedia');

User.belongsTo(User, { foreignKey: 'createdBy', as: 'creator' });
User.hasMany(User, { foreignKey: 'createdBy', as: 'createdUsers' });
User.hasMany(Hostel, { foreignKey: 'wardenId', as: 'hostels' });
Hostel.belongsTo(User, { foreignKey: 'wardenId', as: 'warden' });
Hostel.belongsTo(User, { foreignKey: 'createdBy', as: 'creator' });
User.hasMany(Hostel, { foreignKey: 'createdBy', as: 'createdHostels' });
Hostel.hasMany(Room, { foreignKey: 'hostelId', as: 'rooms' });
Room.belongsTo(Hostel, { foreignKey: 'hostelId', as: 'hostel' });
Room.belongsTo(User, { foreignKey: 'createdBy', as: 'creator' });
User.hasMany(Room, { foreignKey: 'createdBy', as: 'createdRooms' });

Room.hasMany(Inspection, { foreignKey: 'roomId', as: 'inspections' });
Inspection.belongsTo(Room, { foreignKey: 'roomId', as: 'room' });
Inspection.hasMany(InspectionStudent, { foreignKey: 'inspectionId', as: 'students' });
InspectionStudent.belongsTo(Inspection, { foreignKey: 'inspectionId', as: 'inspection' });
Inspection.hasMany(InspectionMedia, { foreignKey: 'inspectionId', as: 'media' });
InspectionMedia.belongsTo(Inspection, { foreignKey: 'inspectionId', as: 'inspection' });
Inspection.belongsTo(User, { foreignKey: 'createdBy', as: 'createdByUser' });
User.hasMany(Inspection, { foreignKey: 'createdBy', as: 'createdInspections' });

module.exports = { sequelize, User, Hostel, Room, Inspection, InspectionStudent, InspectionMedia };
