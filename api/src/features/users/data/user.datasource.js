const db = require('../../../core/database/db');

const findByEmail = (email) =>
  db.query('SELECT * FROM utilisateur WHERE email = $1', [email]);

const create = (user) =>
  db.query(
    `INSERT INTO utilisateur (codeutilisateur, codefonction, nom, prenoms, numcin, datecin, lieucin, adresse, role, email, mdp)
     VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)`,
    [user.codeutilisateur, user.codefonction, user.nom, user.prenoms, user.numCIN, user.dateCIN,
     user.lieuCIN, user.adresse, user.role, user.email, user.mdp]
  );

module.exports = { findByEmail, create };