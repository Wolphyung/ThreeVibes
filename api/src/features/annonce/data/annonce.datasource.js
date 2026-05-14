const db = require("../../../core/database/db");

const AnnonceDatasource = {
  // CREATE
  addAnnonce: async (data) => {
    const sql = `
            INSERT INTO public.annonce 
            (latitude, longitude, codecategorie, dateannonce, contenuannonce, "codeAnnonce")
            VALUES ($1, $2, $3, NOW(), $4, $5)
            RETURNING *`;
    const values = [
      data.latitude,
      data.longitude,
      data.codeCategorie,
      data.contenu,
      data.codeAnnonce,
    ];
    const { rows } = await db.query(sql, values);
    return rows[0];
  },

  // READ ALL
  getAll: async () => {
    const sql = "SELECT * FROM public.annonce ORDER BY dateannonce DESC";
    const { rows } = await db.query(sql);
    return rows;
  },

  // READ ONE
  getById: async (id) => {
    const sql = 'SELECT * FROM public.annonce WHERE "codeAnnonce" = $1';
    const { rows } = await db.query(sql, [id]);
    return rows[0];
  },

  // UPDATE
  update: async (id, data) => {
    const sql = `
            UPDATE public.annonce 
            SET latitude = $1, longitude = $2, codecategorie = $3, contenuannonce = $4
            WHERE "codeAnnonce" = $5
            RETURNING *`;
    const values = [
      data.latitude,
      data.longitude,
      data.codeCategorie,
      data.contenu,
      id,
    ];
    const { rows } = await db.query(sql, values);
    return rows[0];
  },

  // DELETE
  delete: async (id) => {
    const sql =
      'DELETE FROM public.annonce WHERE "codeAnnonce" = $1 RETURNING *';
    const { rows } = await db.query(sql, [id]);
    return rows[0];
  },
};

module.exports = AnnonceDatasource;
