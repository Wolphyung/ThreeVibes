const datasource = require('../data/user.datasource');

const findByEmail = async (email) => {
  const result = await datasource.findByEmail(email);
  return result.rows[0] || null;
};

const findById = async (id) => {
  const result = await datasource.findById(id);
  return result.rows[0] || null;
};

const create = async (user, file) => {
  const result = await datasource.create(user, file);
  return result.rows[0];
};

const update = async (id, user, file) => {
  const result = await datasource.update(id, user, file);
  return result.rows[0] || null;
};

const remove = async (id) => {
  const result = await datasource.remove(id);
  return result.rows[0] || null;
};

const saveResetToken = async (email, token, expires) => {
  return await datasource.saveResetToken(email, token, expires);
};

const findByResetToken = async (token) => {
  const result = await datasource.findByResetToken(token);
  return result.rows[0] || null;
};

const updatePassword = async (id, hashedPassword) => {
  return await datasource.updatePassword(id, hashedPassword);
};

module.exports = { findByEmail, findById, create, update, remove, saveResetToken, findByResetToken, updatePassword };