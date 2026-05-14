const AnnonceDatasource = require("../data/annonce.datasource");
const PJService = require("../../piece-jointe/domain/pj.service");

class AnnonceService {
  async createAnnonce(annonceData, files) {
    const annonce = await AnnonceDatasource.create(annonceData);

    // Si on a des fichiers (upload.array met les fichiers dans req.files)
    if (files && files.length > 0) {
      // On utilise la méthode de ton collaborateur pour tout uploader d'un coup
      const uploadResults = await PJService.uploadMultiple(files);

      // On lie chaque URL à l'annonce dans la table de liaison
      for (const res of uploadResults) {
        await AnnonceDatasource.linkPJ(annonce.codeannonce, res.url);
      }

      // On ajoute les URLs au retour pour confirmation
      annonce.images = uploadResults.map((r) => r.url);
    }

    return annonce;
  }

  listAnnonces = async (search) => {
    return await AnnonceDatasource.getAll(search);
  };

  updateAnnonce = async (id, data) => {
    return await AnnonceDatasource.update(id, data);
  };

  async deleteAnnonce(id) {
    // 1. Récupérer les URLs liées à cette annonce avant de supprimer
    const images = await AnnonceDatasource.getImagesByAnnonce(id);
    const urls = images.map((img) => img.lien);

    // 2. Appeler le service PJ pour le nettoyage physique et SQL des images
    if (urls.length > 0) {
      await PJService.deleteByUrls(urls);
    }

    // 3. Supprimer l'annonce elle-même
    return await AnnonceDatasource.delete(id);
  }
}

module.exports = new AnnonceService();
