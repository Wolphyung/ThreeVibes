/**
 * @swagger
 * /annonces:
 *   get:
 *     tags: [Annonces]
 *     summary: List all annonces (with optional search)
 *     description: Returns all annonces with their category name and attached images. Supports full-text search on content.
 *     parameters:
 *       - in: query
 *         name: q
 *         required: false
 *         schema:
 *           type: string
 *         description: Search term to filter by contenuannonce (case-insensitive)
 *     responses:
 *       200:
 *         description: List of annonces with images
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   codeAnnonce:
 *                     type: string
 *                   contenuannonce:
 *                     type: string
 *                   latitude:
 *                     type: number
 *                   longitude:
 *                     type: number
 *                   codecategorie:
 *                     type: string
 *                   nomcategorie:
 *                     type: string
 *                   dateannonce:
 *                     type: string
 *                     format: date-time
 *                   images:
 *                     type: array
 *                     items:
 *                       type: string
 *       500:
 *         description: Server error
 *   post:
 *     tags: [Annonces]
 *     summary: Create a new annonce with attached files
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             required:
 *               - codeCategorie
 *               - contenu
 *             properties:
 *               latitude:
 *                 type: number
 *                 format: float
 *                 description: Latitude coordinate
 *               longitude:
 *                 type: number
 *                 format: float
 *                 description: Longitude coordinate
 *               codeCategorie:
 *                 type: string
 *                 description: Category code (e.g. C0001)
 *               contenu:
 *                 type: string
 *                 description: Content of the annonce
 *               files:
 *                 type: array
 *                 items:
 *                   type: string
 *                   format: binary
 *                 description: Images to attach (max 5)
 *     responses:
 *       201:
 *         description: Annonce created successfully
 *       500:
 *         description: Server error
 */

/**
 * @swagger
 * /annonces/{id}:
 *   put:
 *     tags: [Annonces]
 *     summary: Update an annonce
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Annonce code (e.g. AN001)
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               latitude:
 *                 type: number
 *                 format: float
 *               longitude:
 *                 type: number
 *                 format: float
 *               codeCategorie:
 *                 type: string
 *               contenu:
 *                 type: string
 *     responses:
 *       200:
 *         description: Annonce updated successfully
 *       500:
 *         description: Server error
 *   delete:
 *     tags: [Annonces]
 *     summary: Delete an annonce and its attached images
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Annonce code (e.g. AN001)
 *     responses:
 *       204:
 *         description: Annonce deleted successfully
 *       500:
 *         description: Server error
 */
