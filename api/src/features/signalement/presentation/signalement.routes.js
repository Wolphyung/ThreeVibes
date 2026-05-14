const express = require('express');
const multer = require('multer');
const SignalementController = require('./signalement.controller');

const router = express.Router();

// Configure multer (in-memory storage)
const storage = multer.memoryStorage();
const upload = multer({ storage: storage });

// POST /api/signalement/create
router.post('/', upload.array('files', 10), (req, res) => SignalementController.create(req, res));

module.exports = router;
