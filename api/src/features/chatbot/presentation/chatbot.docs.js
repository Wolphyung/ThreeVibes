/**
 * @swagger
 * tags:
 *   name: Chatbot
 *   description: AI Chatbot for assistance and dossier tracking
 */

/**
 * @swagger
 * /chatbot/chat:
 *   post:
 *     tags: [Chatbot]
 *     summary: Send a message to the AI chatbot
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - message
 *             properties:
 *               message:
 *                 type: string
 *                 example: "Bonjour, quel est l'état de mon dossier D001 ?"
 *     responses:
 *       200:
 *         description: AI response
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 response:
 *                   type: string
 */
