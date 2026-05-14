// src/features/annonce/presentation/annonce.controller.js

const AnnonceService = require("../domain/annonce.service");

class AnnonceController {
  create = async (req, res) => {
    try {
      // Appelle la méthode correcte du service avec le fichier
      const result = await AnnonceService.createAnnonce(req.body, req.files);
      res.status(201).json(result);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  };

  list = async (req, res) => {
    try {
      const { q } = req.query;
      const annonces = await AnnonceService.listAnnonces(q || "");
      res.json(annonces);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  };

  update = async (req, res) => {
    try {
      const result = await AnnonceService.updateAnnonce(
        req.params.id,
        req.body,
      );
      res.json(result);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  };

  remove = async (req, res) => {
    try {
      await AnnonceService.deleteAnnonce(req.params.id);
      res.status(204).send();
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  };
}

module.exports = new AnnonceController();
