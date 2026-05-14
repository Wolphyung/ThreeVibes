const datasource = require('../data/chatbot.datasource');

const findDossierByCode = async (codedossier) => {
  const result = await datasource.findDossierByCode(codedossier);
  return result.rows[0] || null;
};

const findAllDossiers = async () => {
  const result = await datasource.findAllDossiers();
  return result.rows;
};

module.exports = { findDossierByCode, findAllDossiers };