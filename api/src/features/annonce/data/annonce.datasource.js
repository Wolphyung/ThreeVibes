const db = require("../../../core/database/db");

class AnnonceDatasource {
  async generateCode() {
    const query =
      'SELECT codeAnnonce FROM public.annonce ORDER BY codeAnnonce DESC LIMIT 1';
    const result = await db.query(query);
    let nextNumber = 1;
    if (result.rows.length > 0) {
      // On extrait le nombre du code (ex: "AN005" -> 5) et on ajoute 1
      const lastCode = result.rows[0].codeannonce;
      const lastNumber = parseInt(lastCode.replace("AN", ""));
      nextNumber = lastNumber + 1;
    }

    return `AN${nextNumber.toString().padStart(3, "0")}`;
  }

  async generateCodeCategorie() {
    // On cherche le code le plus élevé au lieu de compter
    const query =
      'SELECT codeCategorie FROM public.categorie ORDER BY codeCategorie DESC LIMIT 1';
    const result = await db.query(query);

    let nextNumber = 1;
    if (result.rows.length > 0) {
      // On extrait le nombre du code (ex: "AN005" -> 5) et on ajoute 1
      const lastCode = result.rows[0].codecategorie;
      const lastNumber = parseInt(lastCode.replace("CA", ""));
      nextNumber = lastNumber + 1;
    }

    return `CA${nextNumber.toString().padStart(3, "0")}`;
  }

  create = async (data) => {
    const codeAnnonce = await this.generateCode();
    const query = `
      INSERT INTO public.annonce (latitude, longitude, codecategorie, dateannonce, contenuannonce, codeAnnonce, etatannonce)
      VALUES ($1, $2, $3, NOW(), $4, $5, 'accepté') RETURNING *`;

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

  createWithDemande = async (data) => {
    const codeAnnonce = await this.generateCode();
    const query = `
      INSERT INTO public.annonce (latitude, longitude, codecategorie, dateannonce, contenuannonce, codeAnnonce, etatannonce)
      VALUES ($1, $2, $3, NOW(), $4, $5, 'en attente de validation') RETURNING *`;
      
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
      SELECT 
        a.*, 
        c.nomcategorie,
        COALESCE(json_agg(pj.lien) FILTER (WHERE pj.lien IS NOT NULL), '[]') AS images
      FROM public.annonce a
      LEFT JOIN public.categorie c ON a.codecategorie = c.codecategorie
      LEFT JOIN public.pjannonce pj ON a.codeAnnonce = pj.codeannonce
      WHERE a.contenuannonce ILIKE $1
      AND a.etatannonce = 'accepté'
      GROUP BY a.codeAnnonce, c.nomcategorie, a.latitude, a.longitude, a.codecategorie, a.dateannonce, a.contenuannonce
      ORDER BY a.dateannonce DESC`;

    const result = await db.query(query, [`%${search}%`]);
    return result.rows;
  }

  async update(id, data) {
    const query = `
      UPDATE public.annonce 
      SET 
        latitude = COALESCE($1, latitude), 
        longitude = COALESCE($2, longitude), 
        codecategorie = COALESCE($3, codecategorie), 
        contenuannonce = COALESCE($4, contenuannonce), 
        etatannonce = COALESCE($5, etatannonce)
      WHERE codeAnnonce = $6 
      RETURNING *`;
    const values = [
      data.latitude,
      data.longitude,
      data.codeCategorie,
      data.contenu,
      data.etatannonce,
      id,
    ];
    const result = await db.query(query, values);
    return result.rows[0];
  }

  async getImagesByAnnonce(codeAnnonce) {
    const query = "SELECT lien FROM public.pjannonce WHERE codeannonce = $1";
    const result = await db.query(query, [codeAnnonce]);
    return result.rows; // Retourne un tableau d'objets [{lien: '...'}, ...]
  }

  // La méthode de suppression de l'annonce
  async delete(codeAnnonce) {
    const query = 'DELETE FROM public.annonce WHERE codeAnnonce = $1';
    const result = await db.query(query, [codeAnnonce]);
    return result.rowCount > 0;
  }

  async linkPJ(codeAnnonce, lien) {
    // On insère dans PJANNONCE qui fait le lien entre l'annonce et la pièce jointe
    const query =
      "INSERT INTO public.pjannonce (codeannonce, lien) VALUES ($1, $2) RETURNING *";
    const result = await db.query(query, [codeAnnonce, lien]);
    return result.rows[0];
  }

  async getAllCategories() {
    const query = 'SELECT * FROM public.categorie ORDER BY nomcategorie ASC';
    const result = await db.query(query);
    return result.rows;
  }

  async updateCategorie(code, data) {
    const query = `
      UPDATE public.categorie 
      SET nomcategorie = $1 
      WHERE codecategorie = $2 RETURNING *`;
    const values = [data.nomcategorie, code];
    const result = await db.query(query, values);
    return result.rows[0];
  }

  async createCategorie(data) {
    const codeCategorie = await this.generateCodeCategorie();
    const query = `
      INSERT INTO public.categorie (codecategorie, nomcategorie) 
      VALUES ($1, $2) RETURNING *`;
    const values = [codeCategorie, data.nomcategorie];
    const result = await db.query(query, values);
    return result.rows[0];
  }

  // --- DEMANDER TABLE CRUD ---

  listDemandes = async (q = "") => {
    const query = `
      SELECT a.* 
      FROM public.annonce a 
      WHERE a.etatannonce <> 'accepté' AND a.etatannonce <> 'refusé'
      AND a.contenuannonce ILIKE $1`;
    const result = await db.query(query, [`%${q}%`]);
    return result.rows;
  }
  
  async addDemande(codeUtilisateur, codeAnnonce) {
    const query = 'INSERT INTO public.demander (codeutilisateur, codeannonce) VALUES ($1, $2) RETURNING *';
    const result = await db.query(query, [codeUtilisateur, codeAnnonce]);
    return result.rows[0];
  }

  async getDemandesByAnnonce(codeAnnonce) {
    const query = `
      SELECT d.*, u.nom, u.prenoms, u.email 
      FROM public.demander d
      JOIN public.utilisateur u ON d.codeutilisateur = u.codeutilisateur
      WHERE d.codeannonce = $1`;
    const result = await db.query(query, [codeAnnonce]);
    return result.rows;
  }

  async getDemandesByUser(codeUtilisateur) {
    const query = `
      SELECT d.*, a.contenuannonce, a.dateannonce 
      FROM public.demander d
      JOIN public.annonce a ON d.codeannonce = a.codeannonce
      WHERE d.codeutilisateur = $1`;
    const result = await db.query(query, [codeUtilisateur]);
    return result.rows;
  }

  async removeDemande(codeUtilisateur, codeAnnonce) {
    const query = 'DELETE FROM public.demander WHERE codeutilisateur = $1 AND codeannonce = $2 RETURNING *';
    const result = await db.query(query, [codeUtilisateur, codeAnnonce]);
    return result.rowCount > 0;
  }
}

module.exports = new AnnonceDatasource();
