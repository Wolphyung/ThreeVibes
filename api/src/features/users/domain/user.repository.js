const datasource = require("../data/user.datasource");

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

const findAll = async (q) => {
  const result = await datasource.findAll(q);
  return result.rows;
};

// --- FONCTION CRUD ---

const findAllFonctions = async () => {
  const result = await datasource.findAllFonctions();
  return result.rows;
};

const findFonctionById = async (id) => {
  const result = await datasource.findFonctionById(id);
  return result.rows[0] || null;
};

const createFonction = async (nomfonction) => {
  const result = await datasource.createFonction(nomfonction);
  return result.rows[0];
};

const updateFonction = async (id, nomfonction) => {
  const result = await datasource.updateFonction(id, nomfonction);
  return result.rows[0] || null;
};

const deleteFonction = async (id) => {
  const result = await datasource.deleteFonction(id);
  return result.rows[0] || null;
};

module.exports = {
  findByEmail,
  findById,
  create,
  update,
  remove,
  saveResetToken,
  findByResetToken,
  updatePassword,
  findAll,
  findAllFonctions,
  findFonctionById,
  createFonction,
  updateFonction,
  deleteFonction,
};
