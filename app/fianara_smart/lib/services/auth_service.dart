import 'dart:convert';
import 'package:http/http.dart' as http;
<<<<<<< HEAD
=======
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_config.dart';
>>>>>>> ad647aa55ee6cea1612beb10935f79bf917b2910
import '../models/user_model.dart';

class AuthService {
  static const String baseUrl = 'https://threevibes.onrender.com/api';
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';

  // Compte administrateur par défaut
  static const String adminEmail = 'admin@test.com';
  static const String adminPassword = '123456';

  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  // Login
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      // Vérifier d'abord si c'est le compte admin local
      if (email == adminEmail && password == adminPassword) {
        // Créer un utilisateur admin local
        final adminUser = UserModel(
          id: 'admin_local',
          codeUtilisateur: 'ADMIN001',
          nom: 'Admin',
          prenoms: 'System',
          numCIN: 'ADMIN001',
          dateCIN: DateTime.now(),
          lieuCIN: 'System',
          adresse: 'Mairie',
          role: UserRole.admin,
          email: adminEmail,
          createdAt: DateTime.now(),
          isActive: true,
          token: 'local_admin_token',
        );

        await _saveAuthData('local_admin_token', adminUser);

        return {
          'success': true,
          'token': 'local_admin_token',
          'user': adminUser,
        };
      }

      // Sinon, appel API normal
      final response = await http.post(
        Uri.parse('$baseUrl/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'mdp': password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final user = UserModel.fromJson(data['user'] ?? data);
        final token = data['token'] ?? 'api_token';

        await _saveAuthData(token, user);

        return {
          'success': true,
          'token': token,
          'user': user,
        };
      } else if (response.statusCode == 401) {
<<<<<<< HEAD
        return {'success': false, 'error': 'Email ou mot de passe incorrect'};
=======
        return {
          'success': false,
          'message': 'Email ou mot de passe incorrect',
        };
>>>>>>> ad647aa55ee6cea1612beb10935f79bf917b2910
      } else {
        return {
          'success': false,
          'message': 'Erreur serveur (${response.statusCode})',
        };
      }
    } catch (e) {
<<<<<<< HEAD
      return {'success': false, 'error': 'Erreur de connexion: $e'};
=======
      return {
        'success': false,
        'message': 'Erreur de connexion: $e',
      };
>>>>>>> ad647aa55ee6cea1612beb10935f79bf917b2910
    }
  }

  // Register
  static Future<Map<String, dynamic>> register(
    Map<String, dynamic> userData,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      if (response.statusCode == 201) {
        return {'success': true, 'message': 'Utilisateur créé avec succès'};
      } else if (response.statusCode == 400) {
        final data = json.decode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Email déjà utilisé',
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur serveur (${response.statusCode})',
        };
      }
    } catch (e) {
<<<<<<< HEAD
      return {'success': false, 'error': 'Erreur de connexion: $e'};
=======
      return {
        'success': false,
        'message': 'Erreur de connexion: $e',
      };
>>>>>>> ad647aa55ee6cea1612beb10935f79bf917b2910
    }
  }

  // Sauvegarder les données d'auth
  static Future<void> _saveAuthData(String token, UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, json.encode(user.toJson()));
    await prefs.setBool(_isLoggedInKey, true);
  }

  // Vérifier si l'utilisateur est connecté
  Future<bool> isLoggedIn() async {
    final prefs = await _prefs;
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Récupérer l'utilisateur actuel
  Future<UserModel?> getCurrentUser() async {
    final prefs = await _prefs;
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      return UserModel.fromJson(json.decode(userJson));
    }
    return null;
  }

  // Récupérer le token
  Future<String?> getToken() async {
    final prefs = await _prefs;
    return prefs.getString(_tokenKey);
  }

  // Déconnexion
  Future<void> logout() async {
    final prefs = await _prefs;
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  // Rafraîchir l'utilisateur
  Future<UserModel?> refreshUser() async {
    final user = await getCurrentUser();
    if (user != null) {
      // Pour le moment, on retourne simplement l'utilisateur stocké
      // Plus tard, on pourra faire un appel API pour récupérer les données à jour
      return user;
    }
    return null;
  }

  // Changer le mot de passe
  Future<Map<String, dynamic>> changePassword(
      String currentPassword, String newPassword) async {
    try {
      final token = await getToken();

      if (token == null) {
        return {'success': false, 'message': 'Non authentifié'};
      }

      final response = await http.post(
        Uri.parse('$baseUrl/users/change-password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Mot de passe modifié'};
      } else {
        return {
          'success': false,
          'message': 'Erreur lors du changement de mot de passe',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur: $e'};
    }
  }
}
