const db = require("../../../core/database/db");
const pjService = require("../../piece-jointe/domain/pj.service");
const pjController = require("../../piece-jointe/presentation/pj.controller");

const findByEmail = (email) =>
  db.query("SELECT * FROM utilisateur WHERE email = $1", [email]);

const findById = (id) =>
  db.query("SELECT * FROM utilisateur WHERE codeutilisateur = $1", [id]);

const generateCodeUtilisateur = async () => {
  const result = await db.query(
    "SELECT codeutilisateur FROM utilisateur ORDER BY codeutilisateur DESC LIMIT 1",
  );
  let nextNumber = 1;

  if (result.rows.length > 0) {
    const lastCode = result.rows[0].codeutilisateur;
    const lastNumber = parseInt(lastCode.replace("U", ""));
    nextNumber = lastNumber + 1;
  }

  return `U${nextNumber.toString().padStart(4, "0")}`;
};

const generateCodeFonction = async () => {
  const result = await db.query(
    "SELECT codefonction FROM fonction ORDER BY codefonction DESC LIMIT 1",
  );
  let nextNumber = 1;

  if (result.rows.length > 0) {
    const lastCode = result.rows[0].codefonction;
    const lastNumber = parseInt(lastCode.replace("FO", ""));
    nextNumber = lastNumber + 1;
  }

  return `FO${nextNumber.toString().padStart(3, "0")}`;
};

const create = async (user, file) => {
  const findQuery = "SELECT codefonction FROM fonction WHERE nomfonction = $1";
  let fonctionRes = await db.query(findQuery, [user.nomfonction]);

  let codeFonction;
  if (fonctionRes.rows.length === 0) {
    codeFonction = await generateCodeFonction();
    const insertFonctionQuery = `INSERT INTO fonction (codefonction, nomfonction) VALUES ($1, $2) RETURNING codefonction`;
    await db.query(insertFonctionQuery, [codeFonction, user.nomfonction]);
  } else {
    codeFonction = fonctionRes.rows[0].codefonction;
  }

  let imageUrl = null;
  if (file) {
    const fileRes = await pjService.uploadAndSave(file);
    imageUrl = fileRes.url;
  }

  const codeUtilisateur = await generateCodeUtilisateur();

  return db.query(
    `INSERT INTO utilisateur (codeutilisateur, codefonction, nom, prenoms, numcin, datecin, lieucin, adresse, role, email, mdp, image_url)
     VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12) RETURNING *`,
    [
      codeUtilisateur,
      codeFonction,
      user.nom,
      user.prenoms,
      user.numCIN,
      user.dateCIN,
      user.lieuCIN,
      user.adresse,
      user.role || "user",
      user.email,
      user.mdp,
      imageUrl,
    ],
  );
};
j;
const update = (id, user, fileUrl = null) => {
  return db.query(
    `UPDATE utilisateur SET 
      nom = COALESCE($1, nom), 
      prenoms = COALESCE($2, prenoms), 
      numcin = COALESCE($3, numcin), 
      datecin = COALESCE($4, datecin),
      lieucin = COALESCE($5, lieucin), 
      adresse = COALESCE($6, adresse), 
      role = COALESCE($7, role), 
      email = COALESCE($8, email),
      image_url = COALESCE($9, image_url)
     WHERE codeutilisateur = $10 RETURNING *`,
    [
      user.nom || null,
      user.prenoms || null,
      user.numCIN || null,
      user.dateCIN || null,
      user.lieuCIN || null,
      user.adresse || null,
      user.role || null,
      user.email || null,
      fileUrl || null,
      fileUrl || user.image_url || null,
      id,
    ],
  );
};

const remove = (id) =>
  db.query("DELETE FROM utilisateur WHERE codeutilisateur = $1 RETURNING *", [
    id,
  ]);

//cas de mdp oublié
const saveResetToken = (email, token, expires) => {
  return db.query(
    "UPDATE utilisateur SET reset_token = $1, reset_expires = $2 WHERE email = $3",
    [token, expires, email],
  );
};

const findByResetToken = (token) => {
  // On cherche l'user dont le token correspond et n'est pas encore expiré
  return db.query(
    "SELECT * FROM utilisateur WHERE reset_token = $1 AND reset_expires > NOW()",
    [token],
  );
};

const updatePassword = (id, newHashedPassword) => {
  return db.query(
    "UPDATE utilisateur SET mdp = $1, reset_token = NULL, reset_expires = NULL WHERE codeutilisateur = $2",
    [newHashedPassword, id],
  );
};

const findAll = (q = "") => {
  const query = `
    SELECT u.*, f.nomfonction 
    FROM utilisateur u
    LEFT JOIN fonction f ON u.codefonction = f.codefonction
    WHERE u.nom ILIKE $1 OR u.prenoms ILIKE $1 OR u.email ILIKE $1
    ORDER BY u.nom ASC`;
  return db.query(query, [`%${q}%`]);
};

module.exports = {
  findByEmail,
  findById,
  create,
  update,
  remove,
  saveResetToken,
  findByResetToken,
  updatePassword,
  findAll,
};

module.exports = {
  findByEmail,
  findById,
  create,
  update,
  remove,
  saveResetToken,
  findByResetToken,
  updatePassword,
};
