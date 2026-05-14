const service = require('../domain/user.service');

const register = async (req, res, next) => {
  try {
    const result = await service.register(req.body);
    res.status(201).json(result);
  } catch (err) {
    next(err); // passe à errors/index.js
  }
};

const login = async (req, res, next) => {
  try {
    const { email, mdp } = req.body;
    const result = await service.login(email, mdp);
    res.status(200).json(result);
  } catch (err) {
    next(err);
  }
};

module.exports = { register, login };