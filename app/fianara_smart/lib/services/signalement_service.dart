// lib/services/signalement_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../core/api_config.dart';

class SignalementService {
  // Récupérer tous les signalements
  static Future<List<dynamic>> getAllSignalements({String? searchQuery}) async {
    try {
      String url = '${ApiConfig.baseUrl}${ApiConfig.signalements}';
      if (searchQuery != null && searchQuery.isNotEmpty) {
        url += '?q=$searchQuery';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'] ?? [];
      } else {
        throw Exception('Erreur lors du chargement des signalements');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  // Récupérer un signalement par son code
  static Future<Map<String, dynamic>> getSignalementByCode(String code) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.signalements}/$code'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Signalement non trouvé');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  // Récupérer les signalements à proximité
  static Future<List<dynamic>> getNearbySignalements({
    required double lat,
    required double lng,
    int count = 10,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${ApiConfig.baseUrl}${ApiConfig.signalementsNearby}?lat=$lat&lng=$lng&count=$count'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Erreur lors du chargement des signalements à proximité');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  // Créer un signalement
  static Future<Map<String, dynamic>> createSignalement({
    required String typeSignalement,
    required String description,
    required double latitude,
    required double longitude,
    required String codeUtilisateur,
    required List<String> fonctions,
    List<File>? files,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.signalements}'),
      );

      request.fields['typeSignalement'] = typeSignalement;
      request.fields['description'] = description;
      request.fields['latitude'] = latitude.toString();
      request.fields['longitude'] = longitude.toString();
      request.fields['codeUtilisateur'] = codeUtilisateur;
      request.fields['fonctions'] = json.encode(fonctions);

      if (files != null) {
        for (var i = 0; i < files.length; i++) {
          request.files.add(await http.MultipartFile.fromPath(
            'files',
            files[i].path,
            contentType: MediaType('image', 'jpeg'),
          ));
        }
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        return {
          'success': true,
          'data': json.decode(responseBody),
        };
      } else {
        return {
          'success': false,
          'error': 'Erreur lors de la création du signalement',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Erreur: $e',
      };
    }
  }

  // Mettre à jour un signalement
  static Future<Map<String, dynamic>> updateSignalement({
    required String code,
    required String typeSignalement,
    required String description,
    required double latitude,
    required double longitude,
    String? status,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'typeSignalement': typeSignalement,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
      };

      if (status != null) {
        data['status'] = status;
      }

      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.signalements}/$code'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': json.decode(response.body),
        };
      } else {
        return {
          'success': false,
          'error': 'Erreur lors de la mise à jour du signalement',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Erreur: $e',
      };
    }
  }

  // Supprimer un signalement
  static Future<bool> deleteSignalement(String code) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.signalements}/$code'),
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Erreur suppression signalement: $e');
      return false;
    }
  }

  // Mettre à jour uniquement le statut d'un signalement
  static Future<Map<String, dynamic>> updateSignalementStatus({
    required String code,
    required String status,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.signalements}/$code'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'status': status}),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Statut mis à jour avec succès',
        };
      } else {
        return {
          'success': false,
          'error': 'Erreur lors de la mise à jour du statut',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Erreur: $e',
      };
    }
  }

  // Récupérer les signalements par utilisateur
  static Future<List<dynamic>> getSignalementsByUser(
      String codeUtilisateur) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${ApiConfig.baseUrl}${ApiConfig.signalements}/user/$codeUtilisateur'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'] ?? [];
      } else {
        throw Exception(
            'Erreur lors du chargement des signalements utilisateur');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  // Récupérer les signalements par statut
  static Future<List<dynamic>> getSignalementsByStatus(String status) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${ApiConfig.baseUrl}${ApiConfig.signalements}?status=$status'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'] ?? [];
      } else {
        throw Exception(
            'Erreur lors du chargement des signalements par statut');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
}
