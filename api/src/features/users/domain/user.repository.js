const datasource = require('../data/user.datasource');

const findByEmail = async (email) => {
  const result = await datasource.findByEmail(email);
  return result.rows[0] || null;
};

const create = async (user) => {
  const result = await datasource.create(user);
  return result;
};

module.exports = { findByEmail, create };