const db = require('../../../core/database/db');

const findAll = () =>
  db.query('SELECT * FROM instruction_dossier');

const findById = (id) =>
  db.query('SELECT * FROM instruction_dossier WHERE codedossier = $1', [id]);

const generateCodeDossier = async () => {
  const result = await db.query('SELECT codedossier FROM instruction_dossier ORDER BY codedossier DESC LIMIT 1');
  let nextNumber = 1;

  if (result.rows.length > 0) {
    const lastCode = result.rows[0].codedossier;
    const lastNumber = parseInt(lastCode.replace("D", ""));
    nextNumber = lastNumber + 1;
  }

  return `D${nextNumber.toString().padStart(4, "0")}`;
};

const create = async (dossier) => {
  const codeDossier = await generateCodeDossier();
  return db.query(
    `INSERT INTO instruction_dossier (codedossier, nomdossier, instructions)
     VALUES ($1, $2, $3) RETURNING *`,
    [codeDossier, dossier.nomdossier, dossier.instructions]
  );
};

const update = (id, dossier) =>
  db.query(
    `UPDATE instruction_dossier SET nomdossier=$1, instructions=$2
     WHERE codedossier=$3 RETURNING *`,
    [dossier.nomdossier, dossier.instructions, id]
  );

const remove = (id) =>
  db.query('DELETE FROM instruction_dossier WHERE codedossier = $1 RETURNING *', [id]);

module.exports = { findAll, findById, create, update, remove };