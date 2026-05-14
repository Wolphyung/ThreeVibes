const signalementDatasource = require('../data/signalement.datasource');

class SignalementService {
  async createSignalement(signalement, PJs) {
    if (!signalement) {
      throw new Error('No signalement provided');
    }

    if (!PJs) {
      throw new Error('No PJs provided');
    }

    const response = await signalementDatasource.createSignalement(signalement, PJs);
    return {
      signalement: response,
    };
  }
}

module.exports = new SignalementService();
