const signalementDatasource = require('../data/signalement.datasource');
const notificationService = require('../../notifications/notification.service');

class SignalementService {
  async createSignalement(signalement, PJs, fonctions) {
    if (!signalement) {
      throw new Error('No signalement provided');
    }
    if (!PJs || PJs.length === 0) {
      throw new Error('No PJs provided');
    }
    const result = await signalementDatasource.createSignalement(signalement, PJs, fonctions);

    // Notify users of the assigned fonctions
    if (result.fonctions && result.fonctions.length > 0) {
      try {
        await notificationService.notifyNewSignalement(result.signalement, result.fonctions);
      } catch (err) {
        console.error('Notification error (non-blocking):', err.message);
      }
    }

    return result;
  }

  async getAllSignalements() {
    return await signalementDatasource.getAllSignalements();
  }

  async getSignalementById(codeSignalement) {
    const result = await signalementDatasource.getSignalementById(codeSignalement);
    if (!result) {
      throw new Error('Signalement not found');
    }
    return result;
  }

  async updateSignalement(codeSignalement, data) {
    const result = await signalementDatasource.updateSignalement(codeSignalement, data);
    if (!result) {
      throw new Error('Signalement not found');
    }
    return result;
  }

  async deleteSignalement(codeSignalement) {
    const result = await signalementDatasource.deleteSignalement(codeSignalement);
    if (!result) {
      throw new Error('Signalement not found');
    }
    return result;
  }

  // ==========================================
  // SPECIALISER
  // ==========================================

  async addSpecialisation(codeSignalement, codeFonction) {
    return await signalementDatasource.addSpecialisation(codeSignalement, codeFonction);
  }

  async removeSpecialisation(codeSignalement, codeFonction) {
    const result = await signalementDatasource.removeSpecialisation(codeSignalement, codeFonction);
    if (!result) {
      throw new Error('Specialisation not found');
    }
    return result;
  }

  async getSpecialisationsBySignalement(codeSignalement) {
    return await signalementDatasource.getSpecialisationsBySignalement(codeSignalement);
  }

  async getSignalementsByFonction(codeFonction) {
    return await signalementDatasource.getSignalementsByFonction(codeFonction);
  }

  // ==========================================
  // SUIVI
  // ==========================================

  async followSignalement(codeSignalement, codeUtilisateur, stateSuivi) {
    return await signalementDatasource.followSignalement(codeSignalement, codeUtilisateur, stateSuivi);
  }

  async  unfollowSignalement(codeSignalement, codeUtilisateur) {
    const result = await signalementDatasource.unfollowSignalement(codeSignalement, codeUtilisateur);
    if (!result) {
      throw new Error('Suivi not found');
    }
    return result;
  }

  async getSignalementsSuivis(codeUtilisateur) {
    return await signalementDatasource.getSignalementsSuivis(codeUtilisateur);
  }
}

module.exports = new SignalementService();
