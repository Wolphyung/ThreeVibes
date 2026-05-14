const db = require('../../../core/database/db');
const pjService = require('../../piece-jointe/domain/pj.service');

class SignalementDatasource {

  generateNextCode(lastCode) {
    if (!lastCode) return 'S0001';
    const currentNumber = parseInt(lastCode.replace('S', ''), 10);
    const nextNumber = currentNumber + 1;
    return `S${nextNumber.toString().padStart(4, '0')}`;
  }

  // CREATE
  async createSignalement(signalement, PJs) {
    const lastCodeResult = await db.query('SELECT codeSignalement FROM SIGNALEMENT ORDER BY codeSignalement DESC LIMIT 1');
    const lastCode = lastCodeResult.rows[0]?.codesignalement;
    const newCode = this.generateNextCode(lastCode);

    const query = 'INSERT INTO SIGNALEMENT (codeSignalement, typeSignalement, description, dateSignalement, latitude, longitude, codeUtilisateur) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *';
    const result = await db.query(query, [newCode, signalement.typeSignalement, signalement.description, signalement.dateSignalement, signalement.latitude, signalement.longitude, signalement.codeUtilisateur]);

    const links = await pjService.uploadMultiple(PJs);

    await Promise.all(links.map(async (link) => {
      await pjService.linkToSignalement(result.rows[0].codesignalement, link.url);
    }));
    return { signalement: result.rows[0], PJ: links };
  }

  // READ ALL
  async getAllSignalements() {
    const result = await db.query('SELECT * FROM SIGNALEMENT ORDER BY dateSignalement DESC');

    await Promise.all(result.rows.map(async (signalement) => {
      const pj = await pjService.getAttachmentsBySignalement(signalement.codesignalement);
      signalement.PJ = pj;
    }));
    return result.rows;
  }

  // READ ONE (with PJs)
  async getSignalementById(codeSignalement) {
    const result = await db.query('SELECT * FROM SIGNALEMENT WHERE codeSignalement = $1', [codeSignalement]);
    if (!result.rows[0]) return null;
    const pjs = await pjService.getAttachmentsBySignalement(codeSignalement);
    return { signalement: result.rows[0], PJ: pjs };
  }

  // UPDATE
  async updateSignalement(codeSignalement, data) {
    const query = `UPDATE SIGNALEMENT 
      SET typeSignalement = COALESCE($2, typeSignalement),
          description = COALESCE($3, description),
          dateSignalement = COALESCE($4, dateSignalement),
          latitude = COALESCE($5, latitude),
          longitude = COALESCE($6, longitude)
      WHERE codeSignalement = $1 RETURNING *`;
    const result = await db.query(query, [
      codeSignalement,
      data.typeSignalement || null,
      data.description || null,
      data.dateSignalement || null,
      data.latitude || null,
      data.longitude || null,
    ]);
    return result.rows[0];
  }

  // DELETE
  async deleteSignalement(codeSignalement) {
    // Delete linked PJs first (FK constraint)
    await pjService.deleteBySignalement(codeSignalement);
    // Delete SUIVRE links
    await db.query('DELETE FROM SUIVRE WHERE CODESIGNALEMENT = $1', [codeSignalement]);
    // Delete SPECIALISER links
    await db.query('DELETE FROM SPECIALISER WHERE CODESIGNALEMENT = $1', [codeSignalement]);
    // Delete the signalement
    const result = await db.query('DELETE FROM SIGNALEMENT WHERE codeSignalement = $1 RETURNING *', [codeSignalement]);
    return result.rows[0];
  }
}

module.exports = new SignalementDatasource();
