const db = require("../../../core/database/db");

class AnnonceDatasource {
  generateCode = async () => {
    const query = "SELECT count(*) FROM public.annonce";
    const result = await db.query(query);
    // parseInt est important car count retourne une string en pg
    const count = parseInt(result.rows[0].count) + 1;
    return `AN${count.toString().padStart(3, "0")}`;
  };

  create = async (data) => {
    const codeAnnonce = await this.generateCode();
    const query = `
      INSERT INTO public.annonce (latitude, longitude, codecategorie, dateannonce, contenuannonce, "codeAnnonce")
      VALUES ($1, $2, $3, NOW(), $4, $5) RETURNING *`;

    const values = [
      data.latitude,
      data.longitude,
      data.codeCategorie,
      data.contenu,
      codeAnnonce,
    ];

    const result = await db.query(query, values);
    return result.rows[0];
  };

  async getAll(search = "") {
    const query = `
      SELECT a.*, c.nomcategorie 
      FROM public.annonce a
      LEFT JOIN public.categorie c ON a.codecategorie = c.codecategorie
      WHERE a.contenuannonce ILIKE $1 
      ORDER BY a.dateannonce DESC`;
    const result = await db.query(query, [`%${search}%`]);
    return result.rows;
  }

  async update(id, data) {
    const query = `
      UPDATE public.annonce 
      SET latitude = $1, longitude = $2, codecategorie = $3, contenuannonce = $4
      WHERE "codeAnnonce" = $5 RETURNING *`;
    const values = [
      data.latitude,
      data.longitude,
      data.codeCategorie,
      data.contenu,
      id,
    ];
    const result = await db.query(query, values);
    return result.rows[0];
  }

  async delete(id) {
    // Suppression des liens avec les PJ d'abord (intégrité référentielle)
    await db.query("DELETE FROM public.pjannonce WHERE codeannonce = $1", [id]);
    await db.query('DELETE FROM public.annonce WHERE "codeAnnonce" = $1', [id]);
    return { success: true };
  }

  async linkPJ(codeAnnonce, lien) {
    const query =
      "INSERT INTO public.pjannonce (codeannonce, lien) VALUES ($1, $2)";
    await db.query(query, [codeAnnonce, lien]);
  }
}

module.exports = new AnnonceDatasource();
