const express = require('express');
const userRouter = require('../features/users/presentation/user.routes');
const attachmentRouter = require('../features/piece-jointe/presentation/pj.routes');
const signalementRouter = require('../features/signalement/presentation/signalement.routes');
const weatherRouter = require('../features/weather/presentation/weather.routes');

const router = express.Router();
const userRoutes = require('../features/users/presentation/user.routes');
const instructionDossierRoutes = require('../features/instructionDossier/presentation/instructionDossier.routes');

// Register features
router.use('/users', userRouter);
router.use('/piece-jointe', attachmentRouter);
router.use('/signalements', signalementRouter);
router.use('/weather', weatherRouter);

router.use('/users', userRoutes);
router.use('/instruction-dossier', instructionDossierRoutes);


module.exports = router;