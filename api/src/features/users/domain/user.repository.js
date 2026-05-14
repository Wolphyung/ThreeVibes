const datasource = require('../data/user.datasource');

const findByEmail = async (email) => {
  const result = await datasource.findByEmail(email);
  return result.rows[0] || null;
};

const findById = async (id) => {
  const result = await datasource.findById(id);
  return result.rows[0] || null;
};

const create = async (user) => {
  const result = await datasource.create(user);
  return result.rows[0];
};

const update = async (id, user) => {
  const result = await datasource.update(id, user);
  return result.rows[0] || null;
};

const remove = async (id) => {
  const result = await datasource.remove(id);
  return result.rows[0] || null;
};

module.exports = { findByEmail, findById, create, update, remove };