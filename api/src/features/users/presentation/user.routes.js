const router = require('express').Router();
const { register, login, update, remove, forgotPassword } = require('./user.controller');

router.post('/register', register);
router.post('/login', login);
router.put('/:id', update);
router.delete('/:id', remove);

<<<<<<< HEAD
/**
 * @swagger
 * /users:
 *   get:
 *     tags: [Users]
 *     summary: Get all users
 *     responses:
 *       200:
 *         description: List of all users
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 data:
 *                   type: array
 *                   items:
 *                     type: object
 */
router.get('/', userController.getAllUsers);

/**
 * @swagger
 * /users/{id}:
 *   get:
 *     tags: [Users]
 *     summary: Get a user by ID
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: User code (e.g. U0001)
 *     responses:
 *       200:
 *         description: User found
 *       404:
 *         description: User not found
 */
router.get('/:id', userController.getUserById);
=======
>>>>>>> nyantsa

router.post('/forgot-password', forgotPassword);

module.exports = router;