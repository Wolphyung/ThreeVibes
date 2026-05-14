const AnnonceDatasource = require("../data/annonce.datasource");
const PJService = require("../../piece-jointe/domain/pj.service");

class AnnonceService {
  createAnnonce = async (annonceData, file) => {
    // 1. Création de l'annonce
    const annonce = await AnnonceDatasource.create(annonceData);

    // 2. Gestion de l'image si elle existe
    if (file) {
      try {
        const { url } = await PJService.uploadAndSave(file);
        await AnnonceDatasource.linkPJ(annonce.codeAnnonce, url);
        annonce.image_url = url;
      } catch (uploadError) {
        console.error("Erreur upload Supabase:", uploadError);
      }
    }
    return annonce;
  };

  listAnnonces = async (search) => {
    return await AnnonceDatasource.getAll(search);
  };

  updateAnnonce = async (id, data) => {
    return await AnnonceDatasource.update(id, data);
  };

  deleteAnnonce = async (id) => {
    return await AnnonceDatasource.delete(id);
  };
}

module.exports = new AnnonceService();
