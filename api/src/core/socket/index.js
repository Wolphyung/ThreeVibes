const { Server } = require('socket.io');

let io = null;

/**
 * Initialize Socket.IO with the HTTP server.
 * Clients join a room named after their codeFonction on connection.
 */
function initSocket(httpServer) {
  io = new Server(httpServer, {
    cors: {
      origin: '*',
      methods: ['GET', 'POST'],
    },
  });

  io.on('connection', (socket) => {
    console.log(`Socket connected: ${socket.id}`);

    // Client sends their codeFonction to join the right room
    // Usage from client: socket.emit('join-fonction', 'F0001')
    socket.on('join-fonction', (codeFonction) => {
      if (codeFonction) {
        socket.join(`fonction-${codeFonction}`);
        console.log(`Socket ${socket.id} joined room fonction-${codeFonction}`);
      }
    });

    // A user can also join by codeUtilisateur for personal notifications
    socket.on('join-user', (codeUtilisateur) => {
      if (codeUtilisateur) {
        socket.join(`user-${codeUtilisateur}`);
        console.log(`Socket ${socket.id} joined room user-${codeUtilisateur}`);
      }
    });

    socket.on('disconnect', () => {
      console.log(`Socket disconnected: ${socket.id}`);
    });
  });

  return io;
}

/**
 * Get the Socket.IO instance (use after initSocket).
 */
function getIO() {
  if (!io) {
    throw new Error('Socket.IO not initialized. Call initSocket(server) first.');
  }
  return io;
}

module.exports = { initSocket, getIO };
