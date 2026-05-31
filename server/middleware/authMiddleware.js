const admin = require('../config/firebase');
const { User } = require('../models');

async function authMiddleware(req, res, next) {
  try {
    const authHeader = req.headers.authorization || '';
    const [scheme, token] = authHeader.split(' ');

    if (scheme !== 'Bearer' || !token) {
      return res.status(401).json({ message: 'Authorization bearer token is required' });
    }

    const decodedToken = await admin.auth().verifyIdToken(token);
    const user = await User.findByPk(decodedToken.uid);

    if (!user) {
      return res.status(403).json({ message: 'User is authenticated but not registered in this system' });
    }

    req.firebaseUser = decodedToken;
    req.user = user;
    return next();
  } catch (error) {
    return res.status(401).json({
      message: 'Invalid or expired token',
      error: error.message,
    });
  }
}

module.exports = authMiddleware;
