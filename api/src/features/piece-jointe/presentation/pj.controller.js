const PJService = require('../domain/pj.service');

class PJController {
  /**
   * Upload a single file
   * POST /api/piece-jointe/upload  (form field: "file")
   */
  async upload(req, res) {
    try {
      const file = req.file;

      if (!file) {
        return res.status(400).json({ error: 'Please upload a file' });
      }

      const result = await PJService.uploadAndSave(file);
      res.status(201).json({
        message: 'File uploaded successfully',
        data: result
      });
    } catch (error) {
      console.error('Upload controller error:', error);
      res.status(500).json({ error: error.message });
    }
  }

  /**
   * Upload multiple files at once
   * POST /api/piece-jointe/upload-multiple  (form field: "files")
   */
  async uploadMultiple(req, res) {
    try {
      const files = req.files;

      if (!files || files.length === 0) {
        return res.status(400).json({ error: 'Please upload at least one file' });
      }

      const results = await PJService.uploadMultiple(files);
      res.status(201).json({
        message: `${results.length} file(s) uploaded successfully`,
        data: results
      });
    } catch (error) {
      console.error('Multiple upload controller error:', error);
      res.status(500).json({ error: error.message });
    }
  }
}

module.exports = new PJController();
