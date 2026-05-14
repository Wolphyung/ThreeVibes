const multer = require('multer');
const upload = multer({ storage: multer.memoryStorage() });
const verifyToken = require('../../../middlewares/auth.middleware');
const { register, login, update, remove, forgotPassword, resetPassword, getMe } = require('./user.controller');
const router = require('express').Router();


router.get('/me', verifyToken, getMe);
router.post('/register', upload.single('image'), register);
router.post('/login', login);
router.put('/:id', upload.single('image'), update);
router.delete('/:id', remove);

router.post('/forgot-password', forgotPassword);
router.post('/reset-password', resetPassword);

module.exports = router;