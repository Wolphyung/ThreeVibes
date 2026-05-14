const db = require('../../../core/database/db');

const findByEmail = (email) =>
  db.query('SELECT * FROM utilisateur WHERE email = $1', [email]);

const create = async (user) => {
  // 1. On cherche si la fonction existe déjà
  const findQuery = 'SELECT codefonction FROM fonction WHERE nomfonction = $1';
  let fonctionRes = await db.query(findQuery, [user.nomfonction]);

  let codeFonction;

  if (fonctionRes.rows.length === 0) {
    // 2. Si elle n'existe pas, on la crée d'abord
    // On génère un code fonction simple (ex: F + timestamp ou on laisse la PK faire)
    // Ici j'utilise un INSERT qui retourne le nouveau codefonction
    const insertFonctionQuery = `
      INSERT INTO fonction (nomfonction) 
      VALUES ($1) 
      RETURNING codefonction`;
    
    const newFonction = await db.query(insertFonctionQuery, [user.nomfonction]);
    codeFonction = newFonction.rows[0].codefonction;
    console.log(`Nouvelle fonction créée : ${user.nomfonction} avec le code ${codeFonction}`);
  } else {
    // Si elle existe, on récupère le code existant
    codeFonction = fonctionRes.rows[0].codefonction;
  }

  // 3. On insère l'utilisateur avec le codeFonction (existant ou nouveau)
  const insertUserQuery = `
    INSERT INTO utilisateur 
    (codefonction, nom, prenoms, numcin, datecin, lieucin, adresse, role, email, mdp)
    VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
    RETURNING *`;

  const values = [
    codeFonction,
    user.nom,
    user.prenoms,
    user.numCIN,
    user.dateCIN,
    user.lieuCIN,
    user.adresse,
    user.role || 'user',
    user.email,
    user.mdp
  ];

  return db.query(insertUserQuery, values);
};

module.exports = { findByEmail, create };



// const db = require('../../../core/database/db');

// const findByEmail = (email) =>
//   db.query('SELECT * FROM utilisateur WHERE email = $1', [email]);

// const create = (user) =>
//   db.query(
//     `INSERT INTO utilisateur (codeutilisateur, codefonction, nom, prenoms, numcin, datecin, lieucin, adresse, role, email, mdp)
//      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)`,
//     [user.codeutilisateur, user.codefonction, user.nom, user.prenoms, user.numCIN, user.dateCIN,
//      user.lieuCIN, user.adresse, user.role, user.email, user.mdp]
//   );

// module.exports = { findByEmail, create };
