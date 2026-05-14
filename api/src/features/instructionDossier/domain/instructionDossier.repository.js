const datasource = require('../data/instructionDossier.datasource');

const findById = async (id) => {
  const result = await datasource.findById(id);
  return result.rows[0] || null;
};


//créer une instruction dossier
const create = async (instruction) => {
  const result = await datasource.create(instruction);
  return result.rows[0] || null;
};

module.exports = { findById, create };