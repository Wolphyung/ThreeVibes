const SignalementService = require('../domain/signalement.service');

class SignalementController {
  async create(req, res) {
    try {
      const signalement = req.body;
      const PJs = req.files;

      if (!PJs) {
        return res.status(400).json({ error: 'Please upload a file' });
      }

      const response = await SignalementService.createSignalement(signalement, PJs);
      res.status(201).json({
        message: 'Signalement created successfully',
        data: response.signalement
      });
    } catch (error) {
      console.error('Create signalement controller error:', error);
      res.status(500).json({ error: error.message });
    }
  }
}

module.exports = new SignalementController();
