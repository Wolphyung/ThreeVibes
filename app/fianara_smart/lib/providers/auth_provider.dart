// lib/providers/auth_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  String? _token;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _token != null && _currentUser != null;

  // Vérifier si l'utilisateur est admin
  bool get isAdmin {
    return _currentUser?.role == UserRole.admin;
  }

  // Vérifier si l'utilisateur est technicien
  bool get isTechnicien {
    return _currentUser?.role == UserRole.technicien;
  }

  // Vérifier si l'utilisateur est citoyen
  bool get isCitoyen {
    return _currentUser?.role == UserRole.citoyen;
  }

  AuthProvider() {
    _loadSavedUser();
  }

  // Charger l'utilisateur sauvegardé
  Future<void> _loadSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final userJson = prefs.getString('user_data');

    if (token != null && userJson != null) {
      _token = token;
      try {
        final Map<String, dynamic> userMap = json.decode(userJson);
        _currentUser = UserModel.fromJson(userMap);
        notifyListeners();
      } catch (e) {
        print('Error loading user: $e');
      }
    }
  }

  // Connexion
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await AuthService.login(email, password);

      if (result['success'] == true) {
        _token = result['token'];
        _currentUser = result['user'];

        // Sauvegarder les données
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);
        await prefs.setString('user_data', json.encode(_currentUser!.toJson()));

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['error'];
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Inscription
  Future<bool> register(Map<String, dynamic> userData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await AuthService.register(userData);

      if (result['success'] == true) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['error'];
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Déconnexion
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');

    _token = null;
    _currentUser = null;
    _isLoading = false;
    notifyListeners();
  }

  // Vérifier le statut d'authentification (pour le splash screen)
  Future<void> checkAuthStatus() async {
    await _loadSavedUser();
  }
}
