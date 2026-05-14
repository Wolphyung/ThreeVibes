const db = require('../../../core/database/db');

const findDossierByCode = (codedossier) =>
  db.query('SELECT * FROM instruction_dossier WHERE codedossier = $1', [codedossier]);

const findAllDossiers = () =>
  db.query('SELECT * FROM instruction_dossier');

module.exports = { findDossierByCode, findAllDossiers };