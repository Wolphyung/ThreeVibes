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
router.delete("/:id", AnnonceController.remove);

router.get("/categories", AnnonceController.listCategories);
router.put("/categories/:id", AnnonceController.updateCategorie);
router.post("/categories", AnnonceController.createCategorie);
// router.delete("/categories/:id", AnnonceController.removeCategorie);

module.exports = router;
