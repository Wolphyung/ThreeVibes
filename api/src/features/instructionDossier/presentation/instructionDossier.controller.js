const service = require('../domain/instructionDossier.service');

const getAll = async (req, res, next) => {
  try {
    const result = await service.getAll();
    res.status(200).json(result);
  } catch (err) { next(err); }
};

const getById = async (req, res, next) => {
  try {
    const result = await service.getById(req.params.id);
    res.status(200).json(result);
  } catch (err) { next(err); }
};

const create = async (req, res, next) => {
  try {
    const result = await service.create(req.body);
    res.status(201).json(result);
  } catch (err) { next(err); }
};

const update = async (req, res, next) => {
  try {
    const result = await service.update(req.params.id, req.body);
    res.status(200).json(result);
  } catch (err) { next(err); }
};

const remove = async (req, res, next) => {
  try {
    const result = await service.remove(req.params.id);
    res.status(200).json(result);
  } catch (err) { next(err); }
};

module.exports = { getAll, getById, create, update, remove };