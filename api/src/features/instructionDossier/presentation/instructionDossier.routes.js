const router = require('express').Router();
const { getAll, getById, create, update, remove } = require('./instructionDossier.controller');

router.get('/', getAll);
router.get('/:id', getById);
router.post('/', create);
router.put('/:id', update);
router.delete('/:id', remove);

module.exports = router;