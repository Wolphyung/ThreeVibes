/**
 * @swagger
 * tags:
 *   name: Instruction Dossier
 *   description: Management of case instructions (dossiers)
 */

/**
 * @swagger
 * /dossiers:
 *   get:
 *     tags: [Instruction Dossier]
 *     summary: Get all dossiers
 *     responses:
 *       200:
 *         description: List of all dossiers
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   codedossier:
 *                     type: string
 *                   nomdossier:
 *                     type: string
 *                   instructions:
 *                     type: string
 *   post:
 *     tags: [Instruction Dossier]
 *     summary: Create a new dossier
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - nomdossier
 *             properties:
 *               nomdossier:
 *                 type: string
 *               instructions:
 *                 type: string
 *     responses:
 *       201:
 *         description: Dossier créé avec succès
 */

/**
 * @swagger
 * /dossiers/{id}:
 *   get:
 *     tags: [Instruction Dossier]
 *     summary: Get a dossier by ID
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Dossier found
 *       404:
 *         description: Dossier introuvable
 *   put:
 *     tags: [Instruction Dossier]
 *     summary: Update a dossier
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               nomdossier:
 *                 type: string
 *               instructions:
 *                 type: string
 *     responses:
 *       200:
 *         description: Dossier mis à jour
 *       404:
 *         description: Dossier introuvable
 *   delete:
 *     tags: [Instruction Dossier]
 *     summary: Delete a dossier
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Dossier supprimé avec succès
 *       404:
 *         description: Dossier introuvable
 */
