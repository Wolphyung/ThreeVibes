const express = require('express');
const userRouter = require('../features/users/presentation/user.routes');
const attachmentRouter = require('../features/piece-jointe/presentation/pj.routes');
const signalementRouter = require('../features/signalement/presentation/signalement.routes');

const router = express.Router();

// Register features
router.use('/users', userRouter);
router.use('/piece-jointe', attachmentRouter);
router.use('/signalements', signalementRouter);

module.exports = router;
