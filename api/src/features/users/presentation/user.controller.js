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
  console.log("--- Tentative d'envoi pour :", email, "---");

  try {
    const user = await datasource.findByEmail(email);
    
    if (user.rows.length === 0) {
      console.log(" Résultat : Email non trouvé en base.");
      return res.status(404).json({ error: "Email non trouvé" });
    }

    // 1. Générer le token
    const token = crypto.randomBytes(20).toString('hex');
    const expires = new Date(Date.now() + 3600000); 

    // 2. Sauvegarder en base
    await datasource.saveResetToken(email, token, expires);
    console.log("Token enregistré en base PostgreSQL.");

    // 3. Configurer l'envoi du mail
    console.log(" Configuration de Nodemailer avec :", process.env.EMAIL_USER);
    const transporter = nodemailer.createTransport({
      service: 'gmail',
      auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS 
      }
    });

    const mailOptions = {
      to: email,
      subject: 'Réinitialisation de mot de passe',
      text: `Vous recevez ceci car vous avez demandé la réinitialisation du mot de passe.\n\n` +
            `Cliquez sur le lien suivant : http://localhost:3000/reset/${token}\n`
    };

    // 4. L'envoi réel
    console.log("Envoi du mail en cours...");
    const info = await transporter.sendMail(mailOptions);
    
    console.log("Email envoyé ! Réponse du serveur :", info.response);
    res.status(200).json({ message: "Email de récupération envoyé !" });

  } catch (err) {
    console.error("ERREUR DÉTECTÉE :", err.message);
    res.status(500).json({ error: err.message });
  }
};

module.exports = { register, login, update, remove, forgotPassword };