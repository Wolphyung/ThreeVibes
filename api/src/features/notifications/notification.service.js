const { getIO } = require('../../core/socket');
const db = require('../../core/database/db');

class NotificationService {
  /**
   * Notify all users belonging to the given fonctions that a new signalement was created.
   * @param {object} signalement - The created signalement object
   * @param {string[]} codeFonctions - Array of codeFonction to notify
   */
  async notifyNewSignalement(signalement, codeFonctions) {
    if (!codeFonctions || codeFonctions.length === 0) return;

    const io = getIO();

    for (const codeFonction of codeFonctions) {
      // Emit to the fonction room
      io.to(`fonction-${codeFonction.trim()}`).emit('new-signalement', {
        type: 'NEW_SIGNALEMENT',
        message: `Nouveau signalement: ${signalement.typesignalement || signalement.typeSignalement}`,
        signalement: signalement,
        codeFonction: codeFonction.trim(),
        timestamp: new Date().toISOString(),
      });

      console.log(`Notification sent to room fonction-${codeFonction.trim()}`);
    }
  }

  /**
   * Notify a specific user (by codeUtilisateur).
   */
  notifyUser(codeUtilisateur, event, data) {
    const io = getIO();
    io.to(`user-${codeUtilisateur}`).emit(event, {
      ...data,
      timestamp: new Date().toISOString(),
    });
  }
}

module.exports = new NotificationService();
