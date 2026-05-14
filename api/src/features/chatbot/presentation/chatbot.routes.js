const router = require('express').Router();
const { chat } = require('./chatbot.controller');

// DOIT ÊTRE /chat et non /chatbot/chat
router.post('/chat', chat);

module.exports = router;