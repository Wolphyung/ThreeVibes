const router = require('express').Router();
const { register, login, update, remove, forgotPassword } = require('./user.controller');

router.post('/register', register);
router.post('/login', login);
router.put('/:id', update);
router.delete('/:id', remove);

router.post('/forgot-password', forgotPassword);

module.exports = router;