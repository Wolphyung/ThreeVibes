const db = require('../../../core/database/db');

class PJDatasource {
  async createPJ(lien) {
    const query = 'INSERT INTO PIECE_JOINTE (LIEN) VALUES ($1) ON CONFLICT (LIEN) DO NOTHING RETURNING *';
    const result = await db.query(query, [lien]);
    return result.rows[0] || { lien };
  }

  // async linkToAnnonce(codeAnnonce, lien) {
  //   const query = 'INSERT INTO PJANNONCE (CODEANNONCE, LIEN) VALUES ($1, $2) RETURNING *';
  //   const result = await db.query(query, [codeAnnonce, lien]);
  //   return result.rows[0];
  // }

  // async linkToSignalement(codeSignalement, lien) {
  //   const query = 'INSERT INTO PJSIGNALEMENT (CODESIGNALEMENT, LIEN) VALUES ($1, $2) RETURNING *';
  //   const result = await db.query(query, [codeSignalement, lien]);
  //   return result.rows[0];
  // }

  // async getAttachmentsByAnnonce(codeAnnonce) {
  //   const query = 'SELECT * FROM PJANNONCE WHERE CODEANNONCE = $1';
  //   const result = await db.query(query, [codeAnnonce]);
  //   return result.rows;
  // }
}

module.exports = new PJDatasource();
