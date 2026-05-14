const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const repo = require('./user.repository');

const register = async (userData) => {
  const existing = await repo.findByEmail(userData.email);
  if (existing) throw new Error('Email déjà utilisé');

  userData.mdp = await bcrypt.hash(userData.mdp, 10);
  const user = await repo.create(userData);
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

const update = async (id, userData) => {
  const existing = await repo.findById(id);
  if (!existing) throw new Error('Utilisateur introuvable');

  const updated = await repo.update(id, userData);
  const { mdp: _, ...userWithoutPassword } = updated;
  return { message: 'Utilisateur mis à jour', user: userWithoutPassword };
};

const remove = async (id) => {
  const existing = await repo.findById(id);
  if (!existing) throw new Error('Utilisateur introuvable');

  await repo.remove(id);
  return { message: 'Compte supprimé avec succès' };
};

module.exports = { register, login, update, remove };