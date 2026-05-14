const PJService = require('../domain/pj.service');

class PJController {
  async upload(req, res) {
    try {
      const file = req.file;

      if (!file) {
        return res.status(400).json({ error: 'Please upload a file' });
      }

      const { lien } = await PJService.uploadAndSave(file);
      res.status(201).json({
        message: 'File uploaded successfully',
        data: lien
      });
    } catch (error) {
      console.error('Upload controller error:', error);
      res.status(500).json({ error: error.message });
    }
  }
}

module.exports = new PJController();
