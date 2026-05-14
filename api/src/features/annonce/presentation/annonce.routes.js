const express = require("express");
const router = express.Router();
const multer = require("multer");
const AnnonceController = require("./annonce.controller");

const upload = multer({ storage: multer.memoryStorage() });

// src/features/annonce/presentation/annonce.routes.js

router.get("/", AnnonceController.list);
router.put("/:id", AnnonceController.update);
// On autorise jusqu'à 5 fichiers simultanés
router.post("/", upload.array("files", 5), AnnonceController.create);
router.post("/create-with-demande", upload.array("files", 5), AnnonceController.createAnnonceWithDemande);
router.delete("/:id", AnnonceController.remove);

router.get("/categories", AnnonceController.listCategories);
router.put("/categories/:id", AnnonceController.updateCategorie);
router.post("/categories", AnnonceController.createCategorie);
// router.delete("/categories/:id", AnnonceController.removeCategorie);

// --- DEMANDER ROUTES ---
// router.post("/demander", AnnonceController.addDemande);
router.get("/demandes", AnnonceController.listDemandes);
router.get("/demandes/annonce/:id", AnnonceController.getDemandesByAnnonce);
router.get("/demandes/user/:id", AnnonceController.getDemandesByUser);
router.put("/demandes/refuse/:codeAnnonce", AnnonceController.refuseDemande);
router.put("/demandes/accept/:codeAnnonce", AnnonceController.acceptDemande);

module.exports = router;
