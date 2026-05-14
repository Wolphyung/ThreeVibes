const service = require("../domain/user.service");
const datasource = require("../data/user.datasource");
const crypto = require("crypto");
const nodemailer = require("nodemailer");
require("dotenv").config();

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
  },
});

//format Json

const register = async (req, res, next) => {
  try {
    const result = await service.register(req.body, req.file);
    res.status(201).json(result);
  } catch (err) {
    next(err);
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

const update = async (req, res, next) => {
  try {
    const result = await service.update(req.params.id, req.body, req.file);
    res.status(200).json(result);
  } catch (err) {
    next(err);
  }
};

const remove = async (req, res, next) => {
  try {
    const result = await service.remove(req.params.id);
    res.status(200).json(result);
  } catch (err) {
    next(err);
  }
};

//mot de passe oublié
const forgotPassword = async (req, res) => {
  const { email } = req.body;
  try {
    const { token } = await service.forgotPassword(email);

    const mailOptions = {
      to: email,
      subject: "Réinitialisation de mot de passe",
      text:
        `Vous recevez ceci car vous avez demandé la réinitialisation du mot de passe.\n\n` +
        `Cliquez sur le lien suivant : http://localhost:3000/reset/${token}\n`,
    };

    await transporter.sendMail(mailOptions);
    res.status(200).json({ message: "Email de récupération envoyé !" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const resetPassword = async (req, res) => {
  const { token, newPassword } = req.body;
  try {
    const result = await service.resetPassword(token, newPassword);
    res.status(200).json(result);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const getMe = async (req, res, next) => {
  try {
    const result = await service.getById(req.user.codeutilisateur);
    res.status(200).json(result);
  } catch (err) {
    next(err);
  }
};

module.exports = {
  register,
  login,
  update,
  remove,
  forgotPassword,
  resetPassword,
  getMe,
};
const getAll = async (req, res, next) => {
  try {
    const { q } = req.query;
    const result = await service.getAllUsers(q || "");
    res.status(200).json(result);
  } catch (err) {
    next(err);
  }
};

// --- FONCTION CRUD ---

const listFonctions = async (req, res, next) => {
  try {
    const result = await service.getAllFonctions();
    res.status(200).json(result);
  } catch (err) {
    next(err);
  }
};

const getFonction = async (req, res, next) => {
  try {
    const result = await service.getFonctionById(req.params.id);
    res.status(200).json(result);
  } catch (err) {
    next(err);
  }
};

const createFonction = async (req, res, next) => {
  try {
    const result = await service.createFonction(req.body.nomfonction);
    res.status(201).json(result);
  } catch (err) {
    next(err);
  }
};

const updateFonction = async (req, res, next) => {
  try {
    const result = await service.updateFonction(
      req.params.id,
      req.body.nomfonction,
    );
    res.status(200).json(result);
  } catch (err) {
    next(err);
  }
};

const deleteFonction = async (req, res, next) => {
  try {
    const result = await service.deleteFonction(req.params.id);
    res.status(200).json(result);
  } catch (err) {
    next(err);
  }
};

module.exports = {
  register,
  login,
  update,
  remove,
  forgotPassword,
  resetPassword,
  getMe,
  getAll,
  listFonctions,
  getFonction,
  createFonction,
  updateFonction,
  deleteFonction,
};
