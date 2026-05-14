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

  listCategories = async (req, res) => {
    try {
      const categories = await AnnonceService.listCategories();
      res.json(categories);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  };

  updateCategorie = async (req, res) => {
    try {
      const result = await AnnonceService.updateCategorie(req.params.id, req.body);
      res.json(result);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  };

  createCategorie = async (req, res) => {
    try {
      const result = await AnnonceService.createCategorie(req.body);
      res.status(201).json(result);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  };

  // --- DEMANDER HANDLERS ---

  listDemandes = async (req, res) => {
    try {
      const { q } = req.query;
      const demandes = await AnnonceService.listDemandes(q || "");
      res.json(demandes);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  };

  addDemande = async (req, res) => {
    try {
      const { codeUtilisateur, codeAnnonce } = req.body;
      const result = await AnnonceService.addDemande(codeUtilisateur, codeAnnonce);
      res.status(201).json(result);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  };

  getDemandesByAnnonce = async (req, res) => {
    try {
      const { id } = req.params;
      const result = await AnnonceService.getDemandesByAnnonce(id);
      res.json(result);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  };

  getDemandesByUser = async (req, res) => {
    try {
      const { id } = req.params;
      const result = await AnnonceService.getDemandesByUser(id);
      res.json(result);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  };

  removeDemande = async (req, res) => {
    try {
      const { codeUtilisateur, codeAnnonce } = req.params;
      const result = await AnnonceService.removeDemande(codeUtilisateur, codeAnnonce);
      res.json({ success: result });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  };

  // ==========================================
    // CREATE WITH DEMANDE
    // ==========================================

    createAnnonceWithDemande = async (req, res) => {
      try {
        const result = await AnnonceService.createAnnonceWithDemande(req.body, req.files);
        res.status(201).json(result);
      } catch (error) {
        res.status(500).json({ error: error.message });
      }
    };

    refuseDemande = async (req, res) => {
      try {
        const { codeAnnonce } = req.params;
        const result = await AnnonceService.refuseDemande(codeAnnonce);
        res.json({ success: result });
      } catch (error) {
        res.status(500).json({ error: error.message });
      }
    };

    acceptDemande = async (req, res) => {
      try {
        const { codeAnnonce } = req.params;
        const result = await AnnonceService.acceptDemande(codeAnnonce);
        res.json({ success: result });
      } catch (error) {
        res.status(500).json({ error: error.message });
      }
    };
}

module.exports = new AnnonceController();
