const repo = require('./instructionDossier.repository');

const getAll = async () => {
  const dossiers = await repo.findAll();
  return { dossiers };
};

const getById = async (id) => {
  const dossier = await repo.findById(id);
  if (!dossier) throw new Error('Dossier introuvable');
  return { dossier };
};

const create = async (data) => {
  const existing = await repo.findById(data.codedossier);
  if (existing) throw new Error('Code dossier déjà utilisé');

  const dossier = await repo.create(data);
  return { message: 'Dossier créé avec succès', dossier };
};

const update = async (id, data) => {
  const existing = await repo.findById(id);
  if (!existing) throw new Error('Dossier introuvable');

  const dossier = await repo.update(id, data);
  return { message: 'Dossier mis à jour', dossier };
};

const remove = async (id) => {
  const existing = await repo.findById(id);
  if (!existing) throw new Error('Dossier introuvable');

  await repo.remove(id);
  return { message: 'Dossier supprimé avec succès' };
};

module.exports = { getAll, getById, create, update, remove };