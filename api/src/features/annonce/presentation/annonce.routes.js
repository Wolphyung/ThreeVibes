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

module.exports = router;
