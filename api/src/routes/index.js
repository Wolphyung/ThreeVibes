const express = require('express');
const userRouter = require('../features/users/presentation/user.routes');
const attachmentRouter = require('../features/piece-jointe/presentation/pj.routes');

const router = express.Router();

// Register features
router.use('/users', userRouter);
router.use('/piece-jointe', attachmentRouter);

module.exports = router;
