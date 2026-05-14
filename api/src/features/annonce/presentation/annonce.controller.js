const AnnonceService = require("../domain/annonce.service");

class AnnonceController {
  create = async (req, res) => {
    try {
      // On passe le body et le fichier au service
      const result = await AnnonceService.createAnnonce(req.body, req.file);
      res.status(201).json(result);
    } catch (error) {
      console.error("Erreur Controller Create:", error.message);
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
      // On passe en 200 avec un petit message JSON
      res.status(200).json({
        message: `L'annonce ${req.params.id} a été supprimée avec succès.`,
      });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  };
}

module.exports = new AnnonceController();
