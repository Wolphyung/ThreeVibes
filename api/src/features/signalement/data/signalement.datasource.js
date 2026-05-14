const db = require('../../../core/database/db');
const pjService = require('../../piece-jointe/domain/pj.service');

class SignalementDatasource {

  generateNextCode(lastCode)  {
    if (!lastCode) return 'S0001';
    const currentNumber = parseInt(lastCode.replace('S', ''), 10);
    const nextNumber = currentNumber + 1;
    return `S${nextNumber.toString().padStart(4, '0')}`;
  };

  async createSignalement(signalement, PJs) {
    const lastCodeResult = await db.query('SELECT codeSignalement FROM SIGNALEMENT ORDER BY codeSignalement DESC LIMIT 1');
    const lastCode = lastCodeResult.rows[0]?.codesignalement; // Attention à la casse selon votre DB
    const newCode = this.generateNextCode(lastCode);

    const query = 'INSERT INTO SIGNALEMENT (codeSignalement, typeSignalement, description, dateSignalement, latitude, longitude, codeUtilisateur) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *';
    const result = await db.query(query, [newCode, signalement.typeSignalement, signalement.description, signalement.dateSignalement, signalement.latitude, signalement.longitude, signalement.codeUtilisateur]);
    const links = await pjService.uploadMultiple(PJs);
    await Promise.all(links.map(async (link) => {
      await pjService.linkToSignalement(result.rows[0].codeSignalement, link.url);
    }));
    return result.rows[0] || { signalement };
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

module.exports = new SignalementDatasource();
