const SignalementService = require('../domain/signalement.service');

class SignalementController {
  // POST /api/signalements
  async create(req, res) {
    try {
      const signalement = req.body;
      const PJs = req.files;

      if (!PJs || PJs.length === 0) {
        return res.status(400).json({ error: 'Please upload at least one file' });
      }

      const response = await SignalementService.createSignalement(signalement, PJs);
      res.status(201).json({
        message: 'Signalement created successfully',
        data: response
      });
    } catch (error) {
      console.error('Create signalement error:', error);
      res.status(500).json({ error: error.message });
    }
  }

  // GET /api/signalements
  async getAll(req, res) {
    try {
      const signalements = await SignalementService.getAllSignalements();
      res.status(200).json({ data: signalements });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  // GET /api/signalements/:code
  async getById(req, res) {
    try {
      const { code } = req.params;
      const result = await SignalementService.getSignalementById(code);
      res.status(200).json({ data: result });
    } catch (error) {
      if (error.message === 'Signalement not found') {
        return res.status(404).json({ error: error.message });
      }
      res.status(500).json({ error: error.message });
    }
  }

  // PUT /api/signalements/:code
  async update(req, res) {
    try {
      const { code } = req.params;
      const data = req.body;
      const result = await SignalementService.updateSignalement(code, data);
      res.status(200).json({
        message: 'Signalement updated successfully',
        data: result
      });
    } catch (error) {
      if (error.message === 'Signalement not found') {
        return res.status(404).json({ error: error.message });
      }
      res.status(500).json({ error: error.message });
    }
  }

  // DELETE /api/signalements/:code
  async delete(req, res) {
    try {
      const { code } = req.params;
      const result = await SignalementService.deleteSignalement(code);
      res.status(200).json({
        message: 'Signalement deleted successfully',
        data: result
      });
    } catch (error) {
      if (error.message === 'Signalement not found') {
        return res.status(404).json({ error: error.message });
      }
      res.status(500).json({ error: error.message });
    }
  }
}

module.exports = new SignalementController();
