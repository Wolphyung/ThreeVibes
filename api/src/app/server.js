require('dotenv').config({ path: require('path').resolve(__dirname, '..', '..', '.env') });


const app = require('./app');
const { PORT } = require('../core/config/env');
const db = require('../core/database/db');

async function startServer() {
  try {
    await db.query('SELECT NOW()');
    console.log('PostgreSQL database connected successfully');
    
    app.listen(PORT, () => {
      console.log(`Server is running on port ${PORT}`);
    });
  } catch (error) {
    console.error('Failed to start server:', error);
    process.exit(1);
  }
}

startServer();