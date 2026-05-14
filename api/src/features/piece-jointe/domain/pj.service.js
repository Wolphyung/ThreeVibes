const supabase = require('../../../core/database/supabase');
const PJDatasource = require('../data/pj.datasource');
const { SUPABASE } = require('../../../core/config/env');
const path = require('path');

class PJService {
  async uploadAndSave(file) {
    if (!file) {
      throw new Error('No file provided');
    }

    const sanitizeFilename = (name) => {
      return name
        .normalize("NFD") // Split accented characters into base + accent
        .replace(/[\u0300-\u036f]/g, "") // Remove the accents
        .replace(/[^a-zA-Z0-9.\-_]/g, "_"); // Replace anything else with underscore
    };

    // Inside your upload function:
    const cleanName = sanitizeFilename(file.originalname);
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

    // Get public URL
    const { data: { publicUrl } } = supabase.storage
      .from(SUPABASE.bucket)
      .getPublicUrl(fileName);

    // Save to PIECE_JOINTE
    await PJDatasource.createPJ(publicUrl);

    return {
      url: publicUrl,
      fileName: fileName,
    };
  }
}

module.exports = new PJService();
