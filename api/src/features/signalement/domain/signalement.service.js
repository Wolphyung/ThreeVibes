const signalementDatasource = require('../data/signalement.datasource');

class SignalementService {
  async createSignalement(signalement, PJs) {
    if (!signalement) {
      throw new Error('No signalement provided');
    }
    if (!PJs || PJs.length === 0) {
      throw new Error('No PJs provided');
    }
    return await signalementDatasource.createSignalement(signalement, PJs);
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
}

module.exports = new SignalementService();
