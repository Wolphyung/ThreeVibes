// lib/core/services/user_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/user_model.dart';

class UserService {
  static const String baseUrl = 'https://threevibes.onrender.com/api';

  // Récupérer tous les utilisateurs (si vous avez un endpoint)
  // Sinon, vous pouvez récupérer via d'autres moyens
  static Future<List<UserModel>> getAllUsers(String token) async {
    try {
      // Note: Votre API ne semble pas avoir d'endpoint GET /users
      // Vous devrez adapter selon ce que votre backend fournit
      // Exemple si vous avez un endpoint:
      final response = await http.get(
        Uri.parse('$baseUrl/users'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors du chargement des utilisateurs');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  // Récupérer un utilisateur par ID
  static Future<UserModel> getUserById(String id, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Utilisateur non trouvé');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  // Mettre à jour un utilisateur
  static Future<bool> updateUser(
      String id, Map<String, dynamic> data, String token) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Erreur lors de la mise à jour');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  // Supprimer un utilisateur
  static Future<bool> deleteUser(String id, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/users/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Erreur lors de la suppression');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  // Créer un utilisateur
  static Future<bool> createUser(
      Map<String, dynamic> userData, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/register'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(userData),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Erreur lors de la création');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
}
