/**
 * @swagger
 * tags:
 *   name: Instruction Dossier
 *   description: Management of case instructions (dossiers)
 */

/**
 * @swagger
 * /instruction-dossier:
 *   get:
 *     tags: [Instruction Dossier]
 *     summary: Get all dossiers
 *     responses:
 *       200:
 *         description: List of all dossiers
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 dossiers:
 *                   type: array
 *                   items:
 *                     type: object
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
 *               - codedossier
 *               - typeinstruction
 *               - descriptioninstruction
 *             properties:
 *               codedossier:
 *                 type: string
 *               typeinstruction:
 *                 type: string
 *               descriptioninstruction:
 *                 type: string
 *               datereception:
 *                 type: string
 *                 format: date-time
 *               etatinstruction:
 *                 type: string
 *     responses:
 *       201:
 *         description: Dossier créé avec succès
 *       400:
 *         description: Code dossier déjà utilisé
 */

/**
 * @swagger
 * /instruction-dossier/{id}:
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
 *               typeinstruction:
 *                 type: string
 *               descriptioninstruction:
 *                 type: string
 *               etatinstruction:
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
