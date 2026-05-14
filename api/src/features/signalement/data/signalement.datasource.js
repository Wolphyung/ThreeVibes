const db = require('../../../core/database/db');
const pjService = require('../../piece-jointe/domain/pj.service');
const notificationService = require('../../notifications/notification.service');

class SignalementDatasource {

  generateNextCode(lastCode) {
  if (!lastCode) return 'S0001';
  const currentNumber = parseInt(lastCode.replace('S', ''), 10);
  const nextNumber = currentNumber + 1;
  if (nextNumber > 9999) {
    throw new Error("Maximum code limit reached (S9999)");
  }
  return `S${nextNumber.toString().padStart(4, '0')}`;
}


  async createSignalement(signalement, PJs, fonctions) {
    // 1. Generate the unique code (S0001 format)
    const lastCodeResult = await db.query('SELECT codeSignalement FROM SIGNALEMENT ORDER BY codeSignalement DESC LIMIT 1');
    const lastCode = lastCodeResult.rows[0]?.codesignalement;
    const newCode = this.generateNextCode(lastCode);

    // 2. Insert the main signalement
    const query = 'INSERT INTO SIGNALEMENT (codeSignalement, typeSignalement, description, dateSignalement, latitude, longitude, codeUtilisateur) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *';
    const result = await db.query(query, [newCode, signalement.typeSignalement, signalement.description, signalement.dateSignalement, signalement.latitude, signalement.longitude, signalement.codeUtilisateur]);
    
    const createdSignalement = result.rows[0];

    // 3. Handle Attachments (PJs)
    const links = await pjService.uploadMultiple(PJs);
    await Promise.all(links.map(async (link) => {
        await pjService.linkToSignalement(createdSignalement.codesignalement, link.url);
    }));

    // 4. Handle Specialisations (Fonctions)
    let specialisations = [];
    if (fonctions && fonctions.length > 0) {
        // If it's a string from a form-data, split it; if it's already an array, use it
        specialisations = typeof fonctions === 'string' ? fonctions.split(',') : fonctions;
        
        await Promise.all(specialisations.map(async (codeFonction) => {
            await this.addSpecialisation(newCode, codeFonction.trim());
        }));

        // --- THE NOTIFICATION STEP ---
        // We notify all the "fonctions" (roles) assigned to this signalement
        try {
            await notificationService.notifyNewSignalement(createdSignalement, specialisations);
        } catch (socketError) {
            console.error("Socket notification failed, but signalement was created:", socketError);
            // We don't block the whole process if the notification fails
        }
    }

    return { 
        signalement: createdSignalement, 
        PJ: links, 
        fonctions: specialisations 
    };
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


  // ==========================================
  // SPECIALISER (Fonction ↔ Signalement)
  // ==========================================

  // Assign a fonction to a signalement
  async addSpecialisation(codeSignalement, codeFonction) {
    const query = 'INSERT INTO SPECIALISER (CODEFONCTION, CODESIGNALEMENT) VALUES ($1, $2) RETURNING *';
    const result = await db.query(query, [codeFonction, codeSignalement]);
    return result.rows[0];
  }

  // Remove a fonction from a signalement
  async removeSpecialisation(codeSignalement, codeFonction) {
    const query = 'DELETE FROM SPECIALISER WHERE CODEFONCTION = $1 AND CODESIGNALEMENT = $2 RETURNING *';
    const result = await db.query(query, [codeFonction, codeSignalement]);
    return result.rows[0];
  }

  // Get all fonctions assigned to a signalement
  async getSpecialisationsBySignalement(codeSignalement) {
    const query = `SELECT S.*, F.NOMFONCTION 
      FROM SPECIALISER S 
      JOIN FONCTION F ON S.CODEFONCTION = F.CODEFONCTION 
      WHERE S.CODESIGNALEMENT = $1`;
    const result = await db.query(query, [codeSignalement]);
    return result.rows;
  }

  // Get all signalements assigned to a fonction
  async getSignalementsByFonction(codeFonction) {
    const query = `SELECT SIG.* 
      FROM SPECIALISER S 
      JOIN SIGNALEMENT SIG ON S.CODESIGNALEMENT = SIG.CODESIGNALEMENT 
      WHERE S.CODEFONCTION = $1
      ORDER BY SIG.DATESIGNALEMENT DESC`;
    const result = await db.query(query, [codeFonction]);
    return result.rows;
  }

  // ==========================================
  // SUIVRE (Utilisateur ↔ Signalement)
  // ==========================================

  // Assign a utilisateur to a signalement
  async followSignalement(codeSignalement, codeUtilisateur, stateSuivi) {
    const lastCodeResult = await db.query('SELECT codesuivi FROM SUIVRE ORDER BY codesuivi DESC LIMIT 1');
    const lastCode = lastCodeResult.rows[0]?.codesuivi;
    const newCode = this.generateNextCode(lastCode);

    const query = 'INSERT INTO SUIVRE (CODESUIVI, CODESIGNALEMENT, CODEUTILISATEUR, ETATSUIVI, DATESUIVI) VALUES ($1, $2, $3, $4, $5) RETURNING *';
    const result = await db.query(query, [newCode, codeSignalement, codeUtilisateur, stateSuivi || "En traitement", new Date()]);
    return result.rows[0];
  }
  


  // Remove a utilisateur from a signalement
  async unfollowSignalement(codeSignalement, codeUtilisateur) {
    const query = 'DELETE FROM SUIVRE WHERE CODESIGNALEMENT = $1 AND CODEUTILISATEUR = $2 RETURNING *';
    const result = await db.query(query, [codeSignalement, codeUtilisateur]);
    return result.rows[0];
  }

  // Get all fonctions assigned to a signalement
  async getSignalementsSuivis(codeUtilisateur) {
    const query = `SELECT SIG.*, S.ETATSUIVI 
      FROM SUIVRE S 
      JOIN SIGNALEMENT SIG ON S.CODESIGNALEMENT = SIG.CODESIGNALEMENT 
      WHERE S.CODEUTILISATEUR = $1`;
    const result = await db.query(query, [codeUtilisateur]);
    return result.rows;
  }

  async getSuiviBySignalement(codeSignalement) {
    const query = `SELECT S.*, U.Nom, U.Prenoms, F.CODEFONCTION, F.NOMFONCTION 
      FROM SUIVRE S 
      JOIN UTILISATEUR U ON S.CODEUTILISATEUR = U.CODEUTILISATEUR
      JOIN FONCTION F ON U.CODEFONCTION = F.CODEFONCTION
      WHERE S.CODESIGNALEMENT = $1`;
    const result = await db.query(query, [codeSignalement]);
    return result.rows;
  }

  async getSuiviState(codeSignalement) {
    const query = `SELECT S.CODESIGNALEMENT, S.ETATSUIVI, S.DATESUIVI
      FROM SUIVRE S 
      WHERE S.CODESIGNALEMENT = $1 ORDER BY S.DATESUIVI DESC LIMIT 1`;
    const result = await db.query(query, [codeSignalement]);
    return result.rows;
  }
}


module.exports = new SignalementDatasource();
