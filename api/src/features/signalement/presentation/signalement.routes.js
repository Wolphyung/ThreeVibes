const express = require('express');
const multer = require('multer');
const SignalementController = require('./signalement.controller');

const router = express.Router();

// Configure multer (in-memory storage)
const storage = multer.memoryStorage();
const upload = multer({ storage: storage });

// ==========================================
// SIGNALEMENT CRUD
// ==========================================

// GET /api/signalements — list all
router.get('/', (req, res) => SignalementController.getAll(req, res));

// GET /api/signalements/by-fonction/:codeFonction — signalements by fonction
router.get('/by-fonction/:codeFonction', (req, res) => SignalementController.getByFonction(req, res));

// GET /api/signalements/nearby?lat=...&lng=...&count=... — nearest signalements
router.get('/nearby', (req, res) => SignalementController.getNearby(req, res));

// GET /api/signalements/:code — get one with PJs
router.get('/:code', (req, res) => SignalementController.getById(req, res));

router.get('/:codeSignalement/suivi', (req, res) => SignalementController.getSuiviSignalement(req, res));

router.get('/:codeSignalement/suivi/etat', (req, res) => SignalementController.getSuiviState(req, res));


// POST /api/signalements — create with files
router.post('/', upload.array('files', 5), (req, res) => SignalementController.create(req, res));

// PUT /api/signalements/:code — update
router.put('/:code', (req, res) => SignalementController.update(req, res));

// DELETE /api/signalements/:code — delete
router.delete('/:code', (req, res) => SignalementController.delete(req, res));

// ==========================================
// SPECIALISER
// ==========================================

// GET /api/signalements/:code/specialisations
router.get('/:code/specialisations', (req, res) => SignalementController.getSpecialisations(req, res));

// POST /api/signalements/:code/specialisations
router.post('/:code/specialisations', (req, res) => SignalementController.addSpecialisation(req, res));

// DELETE /api/signalements/:code/specialisations/:codeFonction
router.delete('/:code/specialisations/:codeFonction', (req, res) => SignalementController.removeSpecialisation(req, res));

// ==========================================
// SUIVI
// ==========================================

// GET /api/signalements/suivi/:codeUtilisateur — signalements suivis by user
router.get('/suivi/:codeUtilisateur', (req, res) => SignalementController.getSuiviByUser(req, res));

// POST /api/signalements/:code/suivi — follow a signalement
router.post('/:code/suivi', (req, res) => SignalementController.follow(req, res));

// DELETE /api/signalements/:code/suivi/:codeUtilisateur — unfollow
router.delete('/:code/suivi/:codeUtilisateur', (req, res) => SignalementController.unfollow(req, res));

module.exports = router;
