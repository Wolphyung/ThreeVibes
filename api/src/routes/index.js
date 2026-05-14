const express = require('express');
const userRouter = require('../features/users/presentation/user.routes');

const router = express.Router();

// Register features
router.use('/users', userRouter);

module.exports = router;
