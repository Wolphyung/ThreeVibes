const userDatasource = require('../data/user.datasource');

class UserRepository {
  async findAll() {
    return await userDatasource.getAllUsers();
  }

  async findById(id) {
    return await userDatasource.getUserById(id);
  }
}

module.exports = new UserRepository();
