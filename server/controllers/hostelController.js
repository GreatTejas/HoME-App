const { Hostel } = require('../models');

async function getHostelByCode(req, res) {
  const hostel = await Hostel.findOne({ where: { hostelCode: req.params.hostelCode } });
  if (!hostel) return res.status(404).json({ message: 'Hostel not found' });
  return res.json(hostel);
}

module.exports = { getHostelByCode };
