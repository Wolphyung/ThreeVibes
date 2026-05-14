const express = require('express');
const router = express.Router();
const verifyToken = require('../middlewares/auth.middleware'); 

const userRoutes = require('../features/users/presentation/user.routes');
const instructionDossierRoutes = require('../features/instructionDossier/presentation/instructionDossier.routes');
const chatbotRoutes = require('../features/chatbot/presentation/chatbot.routes');

router.use('/users', userRoutes);
router.use('/instruction-dossier', instructionDossierRoutes);
router.use('/chatbot', chatbotRoutes);

module.exports = router;