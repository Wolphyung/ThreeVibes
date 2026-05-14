const userRepository = require('./user.repository');

class UserService {
  async getAllUsers() {
    return await userRepository.findAll();
  }

  async getUserById(id) {
    const user = await userRepository.findById(id);
    if (!user) {
      throw new Error('User not found');
    }
    return user;
  }
}

module.exports = new UserService();
