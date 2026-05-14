const db = require('../../../core/database/db');

class UserDatasource {
  async getAllUsers() {
    const result = await db.query('SELECT * FROM utilisateur');
    return result.rows;
  }

  async getUserById(id) {
    const result = await db.query('SELECT * FROM utilisateur WHERE id = $1', [id]);
    return result.rows[0];
  }
}

module.exports = new UserDatasource();
