const http = require('http');
const app = require('./app');
const { PORT } = require('../core/config/env');
const db = require('../core/database/db');
const { initSocket } = require('../core/socket');

async function startServer() {
  try {
    // Check DB connection
    await db.query('SELECT NOW()');

    // Create HTTP server and attach Socket.IO
    const server = http.createServer(app);
    initSocket(server);

    server.listen(PORT, () => {
      console.log(`Server is running on port ${PORT}`);
      console.log(`Socket.IO is ready for connections`);
    });
  } catch (error) {
    console.error('Failed to start server:', error);
    process.exit(1);
  }
}

startServer();
