const express = require("express");
const router = express.Router();
const multer = require("multer");
const AnnonceController = require("./annonce.controller");

const upload = multer({ storage: multer.memoryStorage() });

router.get("/", (req, res) => AnnonceController.list(req, res));
router.post("/", upload.single("file"), (req, res) =>
  AnnonceController.create(req, res),
);
router.put("/:id", (req, res) => AnnonceController.update(req, res));
router.delete("/:id", (req, res) => AnnonceController.remove(req, res));

module.exports = router;
