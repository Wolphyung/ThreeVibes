// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import '../models/user_model.dart';

class AuthService {
  static const String baseUrl = 'https://threevibes.onrender.com/api';

  // Compte administrateur par défaut
  static const String adminEmail = 'admin@test.com';
  static const String adminPassword = '123456';

  // Login
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
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
        body: json.encode({
          'email': email,
          'mdp': password,
        }),
      );

      print('Login Status: ${response.statusCode}');
      print('Login Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return {
          'success': true,
          'token': data['token'],
          'user': UserModel.fromJson(data['user']),
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'error': 'Email ou mot de passe incorrect',
        };
      } else {
        return {
          'success': false,
          'error': 'Erreur serveur (${response.statusCode})',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Erreur de connexion: $e',
      };
    }
  }

  // Register
  static Future<Map<String, dynamic>> register(
      Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      print('Register Status: ${response.statusCode}');
      print('Register Response: ${response.body}');

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Utilisateur créé avec succès',
        };
      } else if (response.statusCode == 400) {
        final data = json.decode(response.body);
        return {
          'success': false,
          'error': data['message'] ?? 'Email déjà utilisé',
        };
      } else {
        return {
          'success': false,
          'error': 'Erreur serveur (${response.statusCode})',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Erreur de connexion: $e',
      };
    }
  }
}
