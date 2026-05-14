const router = require('express').Router();
const { chat } = require('./chatbot.controller');

router.post('/chat', chat);

module.exports = router;