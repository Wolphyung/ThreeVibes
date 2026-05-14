const AnnonceService = require("../domain/annonce.service");

const AnnonceController = {
  create: async (req, res) => {
    try {
      const data = await AnnonceService.create(req.body);
      res.status(201).json(data);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  },
  getAll: async (req, res) => {
    try {
      const data = await AnnonceService.findAll();
      res.json(data);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  },
  getOne: async (req, res) => {
    try {
      const data = await AnnonceService.findOne(req.params.id);
      if (!data) return res.status(404).send("Annonce non trouvée");
      res.json(data);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  },
  update: async (req, res) => {
    try {
      const data = await AnnonceService.update(req.params.id, req.body);
      res.json(data);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  },
  delete: async (req, res) => {
    try {
      await AnnonceService.remove(req.params.id);
      res.status(204).send();
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  },
};

module.exports = AnnonceController;
