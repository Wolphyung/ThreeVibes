const express = require('express');
const multer = require('multer');
const SignalementController = require('./signalement.controller');

const router = express.Router();

// Configure multer (in-memory storage)
const storage = multer.memoryStorage();
const upload = multer({ storage: storage });

// GET /api/signalements — list all
router.get('/', (req, res) => SignalementController.getAll(req, res));

// GET /api/signalements/:code — get one with PJs
router.get('/:code', (req, res) => SignalementController.getById(req, res));

// POST /api/signalements — create with files
router.post('/', upload.array('files', 10), (req, res) => SignalementController.create(req, res));

// PUT /api/signalements/:code — update
router.put('/:code', (req, res) => SignalementController.update(req, res));

// DELETE /api/signalements/:code — delete
router.delete('/:code', (req, res) => SignalementController.delete(req, res));

module.exports = router;
