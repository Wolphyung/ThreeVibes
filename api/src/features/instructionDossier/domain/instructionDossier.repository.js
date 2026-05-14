const datasource = require('../data/instructionDossier.datasource');

const findAll = async () => {
  const result = await datasource.findAll();
  return result.rows;
};

const findById = async (id) => {
  const result = await datasource.findById(id);
  return result.rows[0] || null;
};

const create = async (dossier) => {
  const result = await datasource.create(dossier);
  return result.rows[0];
};

const update = async (id, dossier) => {
  const result = await datasource.update(id, dossier);
  return result.rows[0] || null;
};

const remove = async (id) => {
  const result = await datasource.remove(id);
  return result.rows[0] || null;
};

module.exports = { findAll, findById, create, update, remove };