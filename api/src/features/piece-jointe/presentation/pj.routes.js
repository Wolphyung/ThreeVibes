const express = require('express');
const multer = require('multer');
const PJController = require('./pj.controller');

const router = express.Router();

// Configure multer (in-memory storage)
const storage = multer.memoryStorage();
const upload = multer({ storage: storage });

// POST /api/piece-jointe/upload — single file
router.post('/upload', upload.single('file'), (req, res) => PJController.upload(req, res));

// POST /api/piece-jointe/upload-multiple — multiple files (max 10)
router.post('/upload-multiple', upload.array('files', 10), (req, res) => PJController.uploadMultiple(req, res));

module.exports = router;
