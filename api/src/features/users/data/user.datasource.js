const db = require('../../../core/database/db');
const pjService = require('../../piece-jointe/domain/pj.service');
const pjController = require('../../piece-jointe/presentation/pj.controller');

const findByEmail = (email) =>
  db.query('SELECT * FROM utilisateur WHERE email = $1', [email]);

const findById = (id) =>
  db.query('SELECT * FROM utilisateur WHERE codeutilisateur = $1', [id]);

const generateCodeUtilisateur = async () => {
  const query =
        'SELECT codeutilisateur FROM public.utilisateur ORDER BY codeutilisateur DESC LIMIT 1';
      const result = await db.query(query);
      let nextNumber = 1;
      if (result.rows.length > 0) {
        const lastCode = result.rows[0].codeutilisateur;
        const lastNumber = parseInt(lastCode.replace("U", ""));
        nextNumber = lastNumber + 1;
      }
  
      return `U${nextNumber.toString().padStart(4, "0")}`;
};

const create = async (user, file) => {
  const findQuery = 'SELECT codefonction FROM fonction WHERE nomfonction = $1';
  let fonctionRes = await db.query(findQuery, [user.nomfonction]);

  let codeFonction;
  if (fonctionRes.rows.length === 0) {
    const insertFonctionQuery = `INSERT INTO fonction (nomfonction) VALUES ($1) RETURNING codefonction`;
    const newFonction = await db.query(insertFonctionQuery, [user.nomfonction]);
    codeFonction = newFonction.rows[0].codefonction;
  } else {
    codeFonction = fonctionRes.rows[0].codefonction;
  }

  if (file) {
    const fileRes = await pjService.uploadAndSave(file);
  }

  const codeUtilisateur = await generateCodeUtilisateur();

  return db.query(
    `INSERT INTO utilisateur (codeutilisateur, codefonction, nom, prenoms, numcin, datecin, lieucin, adresse, role, email, mdp)
     VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11) RETURNING *`,
    [codeUtilisateur, codeFonction, user.nom, user.prenoms, user.numCIN, user.dateCIN,
     user.lieuCIN, user.adresse, user.role || 'user', user.email, user.mdp]
  );
};

const update = (id, user) =>
  db.query(
    `UPDATE utilisateur SET nom=$1, prenoms=$2, numcin=$3, datecin=$4,
     lieucin=$5, adresse=$6, role=$7, email=$8 WHERE codeutilisateur=$9 RETURNING *`,
    [user.nom, user.prenoms, user.numCIN, user.dateCIN,
     user.lieuCIN, user.adresse, user.role, user.email, id]
  );

const remove = (id) =>
  db.query('DELETE FROM utilisateur WHERE codeutilisateur = $1 RETURNING *', [id]);

//cas de mdp oublié
const saveResetToken = (email, token, expires) => {
  return db.query(
    'UPDATE utilisateur SET reset_token = $1, reset_expires = $2 WHERE email = $3',
    [token, expires, email]
  );
};

const findByResetToken = (token) => {
  // On cherche l'user dont le token correspond et n'est pas encore expiré
  return db.query(
    'SELECT * FROM utilisateur WHERE reset_token = $1 AND reset_expires > NOW()',
    [token]
  );
};

const updatePassword = (id, newHashedPassword) => {
  return db.query(
    'UPDATE utilisateur SET mdp = $1, reset_token = NULL, reset_expires = NULL WHERE codeutilisateur = $2',
    [newHashedPassword, id]
  );
};


module.exports = { findByEmail, findById, create, update, remove, saveResetToken, findByResetToken, updatePassword };