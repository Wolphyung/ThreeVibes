const db = require('../../../core/database/db');

const findAll = () =>
  db.query('SELECT * FROM instruction_dossier');

const findById = (id) =>
  db.query('SELECT * FROM instruction_dossier WHERE codedossier = $1', [id]);

const create = (dossier) =>
  db.query(
    `INSERT INTO instruction_dossier (nomdossier, instructions)
     VALUES ($1, $2) RETURNING *`,
    [dossier.nomdossier, dossier.instructions]
  );

const update = (id, dossier) =>
  db.query(
    `UPDATE instruction_dossier SET nomdossier=$1, instructions=$2
     WHERE codedossier=$3 RETURNING *`,
    [dossier.nomdossier, dossier.instructions, id]
  );

const remove = (id) =>
  db.query('DELETE FROM instruction_dossier WHERE codedossier = $1 RETURNING *', [id]);

module.exports = { findAll, findById, create, update, remove };