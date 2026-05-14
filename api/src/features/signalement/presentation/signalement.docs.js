/**
 * @swagger
 * /signalements/nearby:
 *   get:
 *     tags: [Signalements]
 *     summary: Get nearest signalements from a position
 *     description: Returns the N closest signalements sorted by distance (in meters) from the given coordinates.
 *     parameters:
 *       - in: query
 *         name: lat
 *         required: true
 *         schema:
 *           type: number
 *           format: float
 *         description: User's latitude
 *       - in: query
 *         name: lng
 *         required: true
 *         schema:
 *           type: number
 *           format: float
 *         description: User's longitude
 *       - in: query
 *         name: count
 *         required: false
 *         schema:
 *           type: integer
 *           default: 10
 *         description: Number of results to return (default 10)
 *     responses:
 *       200:
 *         description: List of nearest signalements with distance in meters
 *       400:
 *         description: lat and lng are required
 */

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
 *               - fonctions
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
 *               fonctions:
 *                 type: array
 *                 items:
 *                   type: string
 *                 description: List of fonction codes to assign (e.g. F0001)
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

/**
 * @swagger
 * /signalements/by-fonction/{codeFonction}:
 *   get:
 *     tags: [Specialisations]
 *     summary: Get all signalements assigned to a fonction
 *     parameters:
 *       - in: path
 *         name: codeFonction
 *         required: true
 *         schema:
 *           type: string
 *         description: Fonction code (e.g. F0001)
 *     responses:
 *       200:
 *         description: List of signalements for the given fonction
 */

/**
 * @swagger
 * /signalements/{code}/specialisations:
 *   get:
 *     tags: [Specialisations]
 *     summary: Get all fonctions assigned to a signalement
 *     parameters:
 *       - in: path
 *         name: code
 *         required: true
 *         schema:
 *           type: string
 *         description: Signalement code (e.g. S0001)
 *     responses:
 *       200:
 *         description: List of fonctions for the signalement
 *   post:
 *     tags: [Specialisations]
 *     summary: Assign a fonction to a signalement
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
 *             required:
 *               - codeFonction
 *             properties:
 *               codeFonction:
 *                 type: string
 *                 description: Fonction code to assign (e.g. F0001)
 *     responses:
 *       201:
 *         description: Fonction assigned to signalement
 *       400:
 *         description: codeFonction is required
 */

/**
 * @swagger
 * /signalements/{code}/specialisations/{codeFonction}:
 *   delete:
 *     tags: [Specialisations]
 *     summary: Remove a fonction from a signalement
 *     parameters:
 *       - in: path
 *         name: code
 *         required: true
 *         schema:
 *           type: string
 *         description: Signalement code (e.g. S0001)
 *       - in: path
 *         name: codeFonction
 *         required: true
 *         schema:
 *           type: string
 *         description: Fonction code to remove (e.g. F0001)
 *     responses:
 *       200:
 *         description: Fonction removed from signalement
 *       404:
 *         description: Specialisation not found
 */

/**
 * @swagger
 * /signalements/suivi/{codeUtilisateur}:
 *   get:
 *     tags: [Suivi]
 *     summary: Get all signalements followed by a user
 *     parameters:
 *       - in: path
 *         name: codeUtilisateur
 *         required: true
 *         schema:
 *           type: string
 *         description: User code (e.g. U0001)
 *     responses:
 *       200:
 *         description: List of signalements followed by the user (with etatSuivi)
 */

/**
 * @swagger
 * /signalements/{code}/suivi:
 *   post:
 *     tags: [Suivi]
 *     summary: Follow a signalement (start tracking)
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
 *             required:
 *               - codeUtilisateur
 *             properties:
 *               codeUtilisateur:
 *                 type: string
 *                 description: User code (e.g. U0001)
 *               etatSuivi:
 *                 type: string
 *                 description: Status (defaults to "En traitement")
 *     responses:
 *       201:
 *         description: Suivi created successfully
 *       400:
 *         description: codeUtilisateur is required
 */

/**
 * @swagger
 * /signalements/{code}/suivi/{codeUtilisateur}:
 *   delete:
 *     tags: [Suivi]
 *     summary: Unfollow a signalement (stop tracking)
 *     parameters:
 *       - in: path
 *         name: code
 *         required: true
 *         schema:
 *           type: string
 *         description: Signalement code (e.g. S0001)
 *       - in: path
 *         name: codeUtilisateur
 *         required: true
 *         schema:
 *           type: string
 *         description: User code (e.g. U0001)
 *     responses:
 *       200:
 *         description: Suivi removed successfully
 *       404:
 *         description: Suivi not found
 */

/**
 * @swagger
 * /signalements/{code}/suivi:
 *   get:
 *     tags: [Suivi]
 *     summary: Get all suivis for a signalement
 *     parameters:
 *       - in: path
 *         name: code
 *         required: true
 *         schema:
 *           type: string
 *         description: Signalement code (e.g. S0001)
 *     responses:
 *       200:
 *         description: List of suivis for the signalement
 */

/**
 * @swagger
 * /signalements/{code}/suivi/etat:
 *   get:
 *     tags: [Signalements]
 *     summary: Get the state of suivis for a signalement
 *     parameters:
 *       - in: path
 *         name: code
 *         required: true
 *         schema:
 *           type: string
 *         description: Signalement code (e.g. S0001)
 *     responses:
 *       200:
 *         description: State of suivis for the signalement
 */


