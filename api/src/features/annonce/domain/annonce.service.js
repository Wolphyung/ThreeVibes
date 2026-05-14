const AnnonceDatasource = require("../data/annonce.datasource");

const AnnonceService = {
  create: (data) => AnnonceDatasource.addAnnonce(data),
  findAll: () => AnnonceDatasource.getAll(),
  findOne: (id) => AnnonceDatasource.getById(id),
  update: (id, data) => AnnonceDatasource.update(id, data),
  remove: (id) => AnnonceDatasource.delete(id),
};

module.exports = AnnonceService;
