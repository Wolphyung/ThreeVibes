const express = require('express');
const multer = require('multer');
const PJController = require('./pj.controller');

const router = express.Router();

// Configure multer (in-memory storage)
const storage = multer.memoryStorage();
const upload = multer({ storage: storage });

// POST /api/PJs/upload
router.post('/upload', upload.single('file'), (req, res) => PJController.upload(req, res));

module.exports = router;
