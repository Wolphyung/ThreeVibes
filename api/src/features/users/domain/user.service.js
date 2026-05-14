const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const repo = require('./user.repository');

const register = async (userData, file) => {
  const existing = await repo.findByEmail(userData.email);
  if (existing) throw new Error('Email déjà utilisé');

  userData.mdp = await bcrypt.hash(userData.mdp, 10);
  const user = await repo.create(userData, file);
  return { message: 'Utilisateur créé avec succès', user };
};

const login = async (email, mdp) => {
  const user = await repo.findByEmail(email);
  if (!user) throw new Error('Utilisateur introuvable');

  const valid = await bcrypt.compare(mdp, user.mdp);
  if (!valid) throw new Error('Mot de passe incorrect');

  const token = jwt.sign(
    { codeutilisateur: user.codeutilisateur, role: user.role },
    process.env.JWT_SECRET,
    { expiresIn: '7d' }
  );

  const { mdp: _, ...userWithoutPassword } = user;
  return { token, user: userWithoutPassword };
};

const update = async (id, userData, file) => {
  const existing = await repo.findById(id);
  if (!existing) throw new Error('Utilisateur introuvable');

  const updated = await repo.update(id, userData, file);
  const { mdp: _, ...userWithoutPassword } = updated;
  return { message: 'Utilisateur mis à jour', user: userWithoutPassword };
};

const remove = async (id) => {
  const existing = await repo.findById(id);
  if (!existing) throw new Error('Utilisateur introuvable');

  await repo.remove(id);
  return { message: 'Compte supprimé avec succès' };
};

const getById = async (id) => {
  const user = await repo.findById(id);
  if (!user) throw new Error('Utilisateur introuvable');
  const { mdp: _, ...userWithoutPassword } = user;
  return userWithoutPassword;
};

const forgotPassword = async (email) => {
  const user = await repo.findByEmail(email);
  if (!user) throw new Error('Utilisateur introuvable');

  const token = require('crypto').randomBytes(20).toString('hex');
  const expires = new Date(Date.now() + 3600000); // 1 heure

  await repo.saveResetToken(email, token, expires);
  return { token, email };
};

const resetPassword = async (token, newPassword) => {
  const user = await repo.findByResetToken(token);
  if (!user) throw new Error('Token de réinitialisation invalide ou expiré');

  const hashedPassword = await bcrypt.hash(newPassword, 10);
  await repo.updatePassword(user.codeutilisateur, hashedPassword);
  return { message: 'Mot de passe réinitialisé avec succès' };
};

const getAllUsers = async (q) => {
  const users = await repo.findAll(q);
  return users.map(user => {
    const { mdp: _, ...userWithoutPassword } = user;
    return userWithoutPassword;
  });
};

// --- FONCTION CRUD ---

const getAllFonctions = async () => {
  return await repo.findAllFonctions();
};

const getFonctionById = async (id) => {
  const fonction = await repo.findFonctionById(id);
  if (!fonction) throw new Error('Fonction introuvable');
  return fonction;
};

const createFonction = async (nomfonction) => {
  return await repo.createFonction(nomfonction);
};

const updateFonction = async (id, nomfonction) => {
  const existing = await repo.findFonctionById(id);
  if (!existing) throw new Error('Fonction introuvable');
  return await repo.updateFonction(id, nomfonction);
};

const deleteFonction = async (id) => {
  const existing = await repo.findFonctionById(id);
  if (!existing) throw new Error('Fonction introuvable');
  return await repo.deleteFonction(id);
};

module.exports = { 
  register, login, update, remove, getById, forgotPassword, 
  resetPassword, getAllUsers,
  getAllFonctions, getFonctionById, createFonction, updateFonction, deleteFonction
};