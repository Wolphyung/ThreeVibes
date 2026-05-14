const signalementDatasource = require('../data/signalement.datasource');
const notificationService = require('../../notifications/notification.service');
const { getDistance } = require('geolib');

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

  async getAllSignalements(q) {
    return await signalementDatasource.getAllSignalements(q);
  }

  /**
   * Get the N nearest signalements from the user's position.
   * @param {number} latitude - User's latitude
   * @param {number} longitude - User's longitude
   * @param {number} count - Number of results to return
   */
  async getNearbySignalements(latitude, longitude, count) {
    const all = await signalementDatasource.getAllSignalements();

    // Compute distance for each signalement
    const withDistance = all
      .filter(s => s.latitude != null && s.longitude != null)
      .map(s => ({
        ...s,
        distance: getDistance(
          { latitude, longitude },
          { latitude: parseFloat(s.latitude), longitude: parseFloat(s.longitude) }
        ),
      }));

    // Sort by distance ascending, take top N
    withDistance.sort((a, b) => a.distance - b.distance);
    return withDistance.slice(0, count);
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

  async getSuiviBySignalement(codeSignalement) {
    return await signalementDatasource.getSuiviBySignalement(codeSignalement);
  }

  async getSuiviState(codeSignalement) {
    return await signalementDatasource.getSuiviState(codeSignalement);
  }
}

module.exports = new SignalementService();
