const service = require('../domain/user.service');
const datasource = require('../data/user.datasource');
const crypto = require('crypto');
const nodemailer = require('nodemailer');
require('dotenv').config();


//format Json

const register = async (req, res, next) => {
  try {
    const result = await service.register(req.body);
    res.status(201).json(result);
  } catch (err) { next(err); }
};

const login = async (req, res, next) => {
  try {
    const { email, mdp } = req.body;
    const result = await service.login(email, mdp);
    res.status(200).json(result);
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


//mot de passe oublié
const forgotPassword = async (req, res) => {
  const { email } = req.body;
  try {
    const user = await datasource.findByEmail(email);
    if (user.rows.length === 0) return res.status(404).json({ error: "Email non trouvé" });

    // 1. Générer le token
    const token = crypto.randomBytes(20).toString('hex');
    const expires = new Date(Date.now() + 3600000); // 1 heure de validité

    // 2. Sauvegarder en base
    await datasource.saveResetToken(email, token, expires);

    // 3. Configurer l'envoi du mail (Exemple avec Gmail ou Mailtrap)
    const transporter = nodemailer.createTransport({
      service: 'gmail',
      auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS // Mot de passe d'application Google
      }
    });

    const mailOptions = {
      to: email,
      subject: 'Réinitialisation de mot de passe',
      text: `Vous recevez ceci car vous avez demandé la réinitialisation du mot de passe.\n\n` +
            `Cliquez sur le lien suivant : http://localhost:3000/reset/${token}\n`
    };

    await transporter.sendMail(mailOptions);
    res.status(200).json({ message: "Email de récupération envoyé !" });

  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

module.exports = { register, login, update, remove, forgotPassword };