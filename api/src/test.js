// Import en CommonJS
const { addAnnonce } = require("./features/annonce/data/annonce.datasource");

// Préparation des données de test basées sur ton modèle SQL
const nouvelleAnnonce = {
  latitude: -21.45267, // Exemple de latitude pour Fianarantsoa
  longitude: 47.08569, // Exemple de longitude pour Fianarantsoa
  codeCategorie: "CAT01", // Doit correspondre à un code existant dans la table categorie
  contenu: "Ceci est une annonce de test pour le projet ThreeVibes",
  codeAnnonce: "ANN01", // Obligatoire car défini comme NOT NULL dans ton SQL
};

// Appel de la fonction asynchrone
addAnnonce(nouvelleAnnonce)
  .then((resultat) => {
    console.log("Annonce insérée avec succès :", resultat);
  })
  .catch((erreur) => {
    console.error("Erreur lors de l'insertion :", erreur.message);
  });
