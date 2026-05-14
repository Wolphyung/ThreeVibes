// lib/providers/admin_users_provider.dart
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class AdminUsersProvider extends ChangeNotifier {
  List<UserModel> _users = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<UserModel> get users => _users;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get totalUsers => _users.length;
  int get activeUsers => _users.where((u) => u.isActive).length;
  int get newUsers => _users.where((u) => u.isNew).length;

  // Charger tous les utilisateurs
  Future<void> fetchUsers(String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _users = await UserService.getAllUsers(token);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Mettre à jour un utilisateur
  Future<bool> updateUser(
      String id, Map<String, dynamic> data, String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await UserService.updateUser(id, data, token);
      if (success) {
        await fetchUsers(token);
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Supprimer un utilisateur
  Future<bool> deleteUser(String id, String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await UserService.deleteUser(id, token);
      if (success) {
        await fetchUsers(token);
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Créer un utilisateur
  Future<bool> createUser(Map<String, dynamic> userData, String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await UserService.createUser(userData, token);
      if (success) {
        await fetchUsers(token);
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
