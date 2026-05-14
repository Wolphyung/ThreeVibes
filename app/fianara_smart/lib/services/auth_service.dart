import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';

  final SharedPreferences? _prefs;

  AuthService({SharedPreferences? prefs}) : _prefs = prefs;

  Future<SharedPreferences> get _instance async =>
      _prefs ?? await SharedPreferences.getInstance();

  // Login simulation (à remplacer par appel API)
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Simuler un appel API
      await Future.delayed(const Duration(seconds: 1));

      // Validation simple
      if (email.isEmpty || password.isEmpty) {
        return {
          'success': false,
          'message': 'Veuillez remplir tous les champs',
        };
      }

      if (password.length < 6) {
        return {
          'success': false,
          'message': 'Mot de passe incorrect',
        };
      }

      // Simuler un utilisateur de test
      final mockUser = UserModel(
        id: 'user_001',
        nom: 'RAKOTO',
        prenoms: 'Jean',
        numCIN: '10123456789',
        dateCIN: DateTime(2020, 1, 1),
        lieuCIN: 'Fianarantsoa',
        adresse: 'Ambatovolo, Fianarantsoa',
        role: email.contains('admin')
            ? UserRole.admin
            : email.contains('tech')
                ? UserRole.technician
                : UserRole.citizen,
        codeUtilisateur: 'CIT_001',
        email: email,
        phoneNumber: '+261341234567',
        createdAt: DateTime.now(),
      );

      final token = _generateToken(mockUser.id);

      await _saveAuthData(token, mockUser);

      return {
        'success': true,
        'message': 'Connexion réussie',
        'user': mockUser,
        'token': token,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de connexion: $e',
      };
    }
  }

  Future<Map<String, dynamic>> register(UserModel user, String password) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      // Validation
      if (user.email.isEmpty || password.isEmpty) {
        return {
          'success': false,
          'message': 'Veuillez remplir tous les champs',
        };
      }

      final token = _generateToken(user.id);
      await _saveAuthData(token, user);

      return {
        'success': true,
        'message': 'Inscription réussie',
        'user': user,
        'token': token,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur d\'inscription: $e',
      };
    }
  }

  Future<void> logout() async {
    final prefs = await _instance;
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await _instance;
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<UserModel?> getCurrentUser() async {
    final prefs = await _instance;
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      return UserModel.fromJson(json.decode(userJson));
    }
    return null;
  }

  Future<String?> getToken() async {
    final prefs = await _instance;
    return prefs.getString(_tokenKey);
  }

  Future<void> _saveAuthData(String token, UserModel user) async {
    final prefs = await _instance;
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, json.encode(user.toJson()));
    await prefs.setBool(_isLoggedInKey, true);
  }

  String _generateToken(String userId) {
    // Simulation de génération de token JWT
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.${_base64Encode(userId)}.${_base64Encode(timestamp.toString())}';
  }

  String _base64Encode(String input) {
    return base64.encode(utf8.encode(input)).replaceAll('=', '');
  }
}
