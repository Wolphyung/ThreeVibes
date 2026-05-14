const service = require('../domain/chatbot.service');

const chat = async (req, res, next) => {
  try {
    const { message, codedossier } = req.body;
    if (!message) return res.status(400).json({ error: 'Message requis' });

    const result = await service.chat(message, codedossier || null);
    res.status(200).json(result);
  } catch (err) { next(err); }
};

module.exports = { chat };