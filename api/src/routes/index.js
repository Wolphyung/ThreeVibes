const express = require('express');
const router = express.Router();
const userRoutes = require('../features/users/presentation/user.routes');
const instructionDossierRoutes = require('../features/instructionDossier/presentation/instructionDossier.routes');


router.use('/users', userRoutes);
router.use('/instruction-dossier', instructionDossierRoutes);


module.exports = router;