const db = require("../../../core/database/db");

class PJDatasource {
  async createPJ(lien) {
    const query =
      "INSERT INTO PIECE_JOINTE (LIEN) VALUES ($1) ON CONFLICT (LIEN) DO NOTHING RETURNING *";
    const result = await db.query(query, [lien]);
    return result.rows[0] || { lien };
  }

  // async linkToAnnonce(codeAnnonce, lien) {
  //   const query = 'INSERT INTO PJANNONCE (CODEANNONCE, LIEN) VALUES ($1, $2) RETURNING *';
  //   const result = await db.query(query, [codeAnnonce, lien]);
  //   return result.rows[0];
  // }

  async linkToSignalement(codeSignalement, lien) {
    const query =
      "INSERT INTO PJSIGNALEMENT (CODESIGNALEMENT, LIEN) VALUES ($1, $2) RETURNING *";
    const result = await db.query(query, [codeSignalement, lien]);
    return result.rows[0];
  }

  async getAttachmentsBySignalement(codeSignalement) {
    const query = "SELECT * FROM PJSIGNALEMENT WHERE CODESIGNALEMENT = $1";
    const result = await db.query(query, [codeSignalement]);
    return result.rows;
  }

  async getOneAttachmentsBySignalement(codeSignalement) {
    const query = "SELECT * FROM PJSIGNALEMENT WHERE CODESIGNALEMENT = $1";
    const result = await db.query(query, [codeSignalement]);
    return result.rows[0];
  }

  async deleteBySignalement(codeSignalement) {
    const query =
      "DELETE FROM PJSIGNALEMENT WHERE CODESIGNALEMENT = $1 RETURNING *";
    const result = await db.query(query, [codeSignalement]);
    return result.rows;
  }

  async deletePJ(lien) {
    const query = "DELETE FROM PIECE_JOINTE WHERE LIEN = $1";
    await db.query(query, [lien]);
  }
  async deleteByUrls(urls) {
    console.log("Type de PJDatasource:", typeof PJDatasource);
    console.log(
      "Méthodes de PJDatasource:",
      Object.getOwnPropertyNames(Object.getPrototypeOf(PJDatasource)),
    );
    const query = "DELETE FROM public.piece_jointe WHERE lien = ANY($1)";
    await db.query(query, [urls]);
  }
}

module.exports = new PJDatasource();
