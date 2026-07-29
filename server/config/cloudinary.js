const crypto = require('crypto');

function createUploadSignature(resourceType) {
  if (!['image', 'video'].includes(resourceType)) {
    const error = new Error('resourceType must be image or video');
    error.statusCode = 400;
    throw error;
  }
  if (!process.env.CLOUDINARY_CLOUD_NAME || !process.env.CLOUDINARY_API_KEY || !process.env.CLOUDINARY_API_SECRET) {
    const error = new Error('Cloudinary credentials are not configured');
    error.statusCode = 500;
    throw error;
  }
  const timestamp = Math.floor(Date.now() / 1000);
  const folder = 'home-app/inspections';
  const signature = crypto
    .createHash('sha1')
    .update(`folder=${folder}&timestamp=${timestamp}${process.env.CLOUDINARY_API_SECRET}`)
    .digest('hex');
  return { cloudName: process.env.CLOUDINARY_CLOUD_NAME, apiKey: process.env.CLOUDINARY_API_KEY, timestamp, folder, signature, resourceType };
}

module.exports = { createUploadSignature };
