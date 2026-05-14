const supabase = require('../../../core/database/supabase');
const PJDatasource = require('../data/pj.datasource');
const { SUPABASE } = require('../../../core/config/env');

class PJService {
  /**
   * Sanitize a filename: remove accents & special characters
   */
  sanitizeFilename(name) {
    return name
      .normalize("NFD")
      .replace(/[\u0300-\u036f]/g, "")
      .replace(/[^a-zA-Z0-9.\-_]/g, "_");
  }

  /**
   * Upload a single file to Supabase and save its URL to PIECE_JOINTE
   */
  async uploadOne(file) {
    const cleanName = this.sanitizeFilename(file.originalname);
    const fileName = `${Date.now()}-${cleanName}`;

    const { data, error } = await supabase.storage
      .from(SUPABASE.bucket)
      .upload(fileName, file.buffer, {
        contentType: file.mimetype,
        upsert: false
      });

    if (error) {
      throw new Error(`Supabase upload error: ${error.message}`);
    }

    const { data: { publicUrl } } = supabase.storage
      .from(SUPABASE.bucket)
      .getPublicUrl(fileName);

    // Save to PIECE_JOINTE table
    await PJDatasource.createPJ(publicUrl);

    return { url: publicUrl, fileName };
  }

  /**
   * Upload a single file (backward compatible)
   */
  async uploadAndSave(file) {
    if (!file) {
      throw new Error('No file provided');
    }
    return await this.uploadOne(file);
  }

  /**
   * Upload multiple files at once
   */
  async uploadMultiple(files) {
    if (!files || files.length === 0) {
      throw new Error('No files provided');
    }

    const results = [];
    for (const file of files) {
      const result = await this.uploadOne(file);
      results.push(result);
    }
    return results;
  }

  async linkToSignalement(codeSignalement, lien) {
    return await PJDatasource.linkToSignalement(codeSignalement, lien);
  }
}

module.exports = new PJService();
