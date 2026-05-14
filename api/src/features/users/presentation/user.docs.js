/**
 * @swagger
 * tags:
 *   name: Users
 *   description: User management and authentication
 */

/**
 * @swagger
 * /users/me:
 *   get:
 *     tags: [Users]
 *     summary: Get current authenticated user profile
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: User profile retrieved successfully
 *       401:
 *         description: Unauthorized
 */

/**
 * @swagger
 * /users/register:
 *   post:
 *     tags: [Users]
 *     summary: Register a new user
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             required:
 *               - email
 *               - mdp
 *               - nomfonction
 *               - nom
 *               - role
 *             properties:
 *               email:
 *                 type: string
 *               mdp:
 *                 type: string
 *               nomfonction:
 *                 type: string
 *                 description: Name of the function/role (e.g., "Agent de Voirie")
 *               nom:
 *                 type: string
 *               prenoms:
 *                 type: string
 *               numCIN:
 *                 type: string
 *               dateCIN:
 *                 type: string
 *                 format: date
 *               lieuCIN:
 *                 type: string
 *               adresse:
 *                 type: string
 *               role:
 *                 type: string
 *                 enum: [ADMIN, USER, AGENT]
 *               image:
 *                 type: string
 *                 format: binary
 *                 description: Profile picture (optional)
 *     responses:
 *       201:
 *         description: Utilisateur créé avec succès
 *       400:
 *         description: Email déjà utilisé
 *       500:
 *         description: Erreur serveur
 */

/**
 * @swagger
 * /users/login:
 *   post:
 *     tags: [Users]
 *     summary: Login a user
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - email
 *               - mdp
 *             properties:
 *               email:
 *                 type: string
 *               mdp:
 *                 type: string
 *     responses:
 *       200:
 *         description: Login successful
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 token:
 *                   type: string
 *                 user:
 *                   type: object
 *       401:
 *         description: Invalid credentials
 */

/**
 * @swagger
 * /users/{id}:
 *   put:
 *     tags: [Users]
 *     summary: Update a user
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             properties:
 *               nom:
 *                 type: string
 *               prenoms:
 *                 type: string
 *               numCIN:
 *                 type: string
 *               dateCIN:
 *                 type: string
 *                 format: date
 *               lieuCIN:
 *                 type: string
 *               adresse:
 *                 type: string
 *               role:
 *                 type: string
 *               email:
 *                 type: string
 *               image:
 *                 type: string
 *                 format: binary
 *                 description: Profile picture update (optional)
 *     responses:
 *       200:
 *         description: User updated
 *       404:
 *         description: Utilisateur introuvable
 *   delete:
 *     tags: [Users]
 *     summary: Delete a user
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: User ID
 *     responses:
 *       200:
 *         description: Compte supprimé avec succès
 *       404:
 *         description: Utilisateur introuvable
 */

/**
 * @swagger
 * /users/forgot-password:
 *   post:
 *     tags: [Users]
 *     summary: Request password reset email
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - email
 *             properties:
 *               email:
 *                 type: string
 *     responses:
 *       200:
 *         description: Email de récupération envoyé !
 *       404:
 *         description: Email non trouvé
 */

/**
 * @swagger
 * /users/reset-password:
 *   post:
 *     tags: [Users]
 *     summary: Reset password using token
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - token
 *               - newPassword
 *             properties:
 *               token:
 *                 type: string
 *               newPassword:
 *                 type: string
 *     responses:
 *       200:
 *         description: Mot de passe r�initialis� avec succ�s
 *       400:
 *         description: Token invalide ou expir�
 */
