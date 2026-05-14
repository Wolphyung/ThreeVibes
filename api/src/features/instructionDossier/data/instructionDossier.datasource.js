const db = require('../../../core/database/db');

const findById = (id) =>
  db.query('SELECT * FROM instruction_dossier WHERE id = $1', [id]);

const create = (instruction) =>
  db.query(
    `INSERT INTO instruction_dossier (codedossier,nomdossier, instructions, ) VALUES ($1, $2, $3)`,
    [instruction.codedossier, instruction.nomdossier, instruction.instructions]
  );

module.exports = { findById, create };