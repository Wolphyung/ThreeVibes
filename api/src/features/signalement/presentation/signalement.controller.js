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
      const fonctions = req.body.fonctions || [];
      const response = await SignalementService.createSignalement(signalement, PJs, fonctions);
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
      const { q } = req.query;
      const signalements = await SignalementService.getAllSignalements(q || "");
      res.status(200).json({ data: signalements });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  // GET /api/signalements/nearby?lat=...&lng=...&count=...
  async getNearby(req, res) {
    try {
      const { lat, lng, count } = req.query;
      if (!lat || !lng) {
        return res.status(400).json({ error: 'lat and lng query parameters are required' });
      }
      const limit = parseInt(count) || 10;
      const result = await SignalementService.getNearbySignalements(
        parseFloat(lat),
        parseFloat(lng),
        limit
      );
      res.status(200).json({ data: result });
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
  // ==========================================
  // SPECIALISER
  // ==========================================

  // POST /api/signalements/:code/specialisations
  async addSpecialisation(req, res) {
    try {
      const { code } = req.params;
      const { codeFonction } = req.body;
      if (!codeFonction) {
        return res.status(400).json({ error: 'codeFonction is required' });
      }
      const result = await SignalementService.addSpecialisation(code, codeFonction);
      res.status(201).json({
        message: 'Fonction assigned to signalement',
        data: result
      });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  // DELETE /api/signalements/:code/specialisations/:codeFonction
  async removeSpecialisation(req, res) {
    try {
      const { code, codeFonction } = req.params;
      const result = await SignalementService.removeSpecialisation(code, codeFonction);
      res.status(200).json({
        message: 'Fonction removed from signalement',
        data: result
      });
    } catch (error) {
      if (error.message === 'Specialisation not found') {
        return res.status(404).json({ error: error.message });
      }
      res.status(500).json({ error: error.message });
    }
  }

  // GET /api/signalements/:code/specialisations
  async getSpecialisations(req, res) {
    try {
      const { code } = req.params;
      const result = await SignalementService.getSpecialisationsBySignalement(code);
      res.status(200).json({ data: result });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  // GET /api/signalements/by-fonction/:codeFonction
  async getByFonction(req, res) {
    try {
      const { codeFonction } = req.params;
      const result = await SignalementService.getSignalementsByFonction(codeFonction);
      res.status(200).json({ data: result });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
  // ==========================================
  // SUIVI
  // ==========================================

  // POST /api/signalements/:code/suivi
  async follow(req, res) {
    try {
      const { code } = req.params;
      const { codeUtilisateur, etatSuivi } = req.body;
      if (!codeUtilisateur) {
        return res.status(400).json({ error: 'codeUtilisateur is required' });
      }
      const result = await SignalementService.followSignalement(code, codeUtilisateur, etatSuivi);
      res.status(201).json({
        message: 'Suivi created successfully',
        data: result
      });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  // DELETE /api/signalements/:code/suivi/:codeUtilisateur
  async unfollow(req, res) {
    try {
      const { code, codeUtilisateur } = req.params;
      const result = await SignalementService.unfollowSignalement(code, codeUtilisateur);
      res.status(200).json({
        message: 'Suivi removed successfully',
        data: result
      });
    } catch (error) {
      if (error.message === 'Suivi not found') {
        return res.status(404).json({ error: error.message });
      }
      res.status(500).json({ error: error.message });
    }
  }

  // GET /api/signalements/suivi/:codeUtilisateur
  async getSuiviByUser(req, res) {
    try {
      const { codeUtilisateur } = req.params;
      const result = await SignalementService.getSignalementsSuivis(codeUtilisateur);
      res.status(200).json({ data: result });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
  async getSuiviSignalement(req, res) {
    try {
      const { codeSignalement } = req.params;
      const result = await SignalementService.getSuiviBySignalement(codeSignalement);
      res.status(200).json({ data: result });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  async getSuiviState(req, res){
    try {
      const { codeSignalement } = req.params;
      const result = await SignalementService.getSuiviState(codeSignalement);
      res.status(200).json({ data: result });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
}

module.exports = new SignalementController();
