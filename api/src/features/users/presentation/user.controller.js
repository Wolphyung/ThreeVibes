const userService = require('../domain/user.service');

class UserController {
  async getAllUsers(req, res) {
    try {
      const users = await userService.getAllUsers();
      res.json(users);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  async getUserById(req, res) {
    try {
      const user = await userService.getUserById(req.params.id);
      res.json(user);
    } catch (error) {
      const status = error.message === 'User not found' ? 404 : 500;
      res.status(status).json({ error: error.message });
    }
  }
}

module.exports = new UserController();
