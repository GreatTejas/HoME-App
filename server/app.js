const express = require('express');
const cors = require('cors');
require('dotenv').config();

const { sequelize } = require('./models');
const userRoutes = require('./routes/userRoutes');
const hostelRoutes = require('./routes/hostelRoutes');
const roomRoutes = require('./routes/roomRoutes');
const storageRoutes = require('./routes/storageRoutes');

const app = express();
const port = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

app.use('/api/users', userRoutes);
app.use('/api/hostels', hostelRoutes);
app.use('/api/rooms', roomRoutes);
app.use('/api/storage-items', storageRoutes);

app.use((req, res) => {
  res.status(404).json({ message: 'Route not found' });
});

app.use((error, req, res, next) => {
  const statusCode = error.name === 'SequelizeValidationError' ? 400 : 500;

  res.status(statusCode).json({
    message: error.message || 'Internal server error',
  });
});

async function startServer() {
  try {
    await sequelize.authenticate();
    console.log('Database connection established');

    app.listen(port, () => {
      console.log(`Server running on port ${port}`);
    });
  } catch (error) {
    console.error('Unable to start server:', error);
    process.exit(1);
  }
}

if (require.main === module) {
  startServer();
}

module.exports = app;
