const service = require('../domain/chatbot.service');

const chat = async (req, res, next) => {
  console.log("===> Chatbot appelé avec le message:", req.body.message);
  try {
    // On récupère "message" (ton champ Postman)
    const { message, codedossier } = req.body;

    if (!message) {
      return res.status(400).json({ error: "Le champ 'message' est requis" });
    }

    // On appelle ton service
    const result = await service.chat(message, codedossier || null);

    // ON RENVOIE LE FORMAT STRICT DEMANDÉ
    return res.status(200).json({
      reponse: result.response,
      source: result.source
    });

  } catch (err) {
    next(err);
  }
};

module.exports = { chat };