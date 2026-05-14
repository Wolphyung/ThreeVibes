/**
 * @swagger
 * /signalements:
 *   get:
 *     tags: [Signalements]
 *     summary: Get all signalements
 *     responses:
 *       200:
 *         description: List of all signalements
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 data:
 *                   type: array
 *                   items:
 *                     type: object
 *   post:
 *     tags: [Signalements]
 *     summary: Create a new signalement with attached files
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             required:
 *               - typeSignalement
 *               - description
 *               - latitude
 *               - longitude
 *               - codeUtilisateur
 *               - files
 *             properties:
 *               typeSignalement:
 *                 type: string
 *               description:
 *                 type: string
 *               dateSignalement:
 *                 type: string
 *                 format: date-time
 *               latitude:
 *                 type: number
 *                 format: float
 *               longitude:
 *                 type: number
 *                 format: float
 *               codeUtilisateur:
 *                 type: string
 *               files:
 *                 type: array
 *                 items:
 *                   type: string
 *                   format: binary
 *                 description: Attached files (max 10)
 *     responses:
 *       201:
 *         description: Signalement created successfully
 *       400:
 *         description: Missing files
 *       500:
 *         description: Server error
 */

/**
 * @swagger
 * /signalements/{code}:
 *   get:
 *     tags: [Signalements]
 *     summary: Get a signalement by code (with attached files)
 *     parameters:
 *       - in: path
 *         name: code
 *         required: true
 *         schema:
 *           type: string
 *         description: Signalement code (e.g. S0001)
 *     responses:
 *       200:
 *         description: Signalement with its attached files
 *       404:
 *         description: Signalement not found
 *   put:
 *     tags: [Signalements]
 *     summary: Update a signalement
 *     parameters:
 *       - in: path
 *         name: code
 *         required: true
 *         schema:
 *           type: string
 *         description: Signalement code (e.g. S0001)
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               typeSignalement:
 *                 type: string
 *               description:
 *                 type: string
 *               dateSignalement:
 *                 type: string
 *                 format: date-time
 *               latitude:
 *                 type: number
 *                 format: float
 *               longitude:
 *                 type: number
 *                 format: float
 *     responses:
 *       200:
 *         description: Signalement updated successfully
 *       404:
 *         description: Signalement not found
 *   delete:
 *     tags: [Signalements]
 *     summary: Delete a signalement and its attached files
 *     parameters:
 *       - in: path
 *         name: code
 *         required: true
 *         schema:
 *           type: string
 *         description: Signalement code (e.g. S0001)
 *     responses:
 *       200:
 *         description: Signalement deleted successfully
 *       404:
 *         description: Signalement not found
 */
