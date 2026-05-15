import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../core/api_config.dart';

class SignalementService {
  // Récupérer tous les signalements
  static Future<List<Map<String, dynamic>>> getAllSignalements(
      {String? searchQuery}) async {
    try {
      String url = '${ApiConfig.baseUrl}${ApiConfig.signalements}';
      if (searchQuery != null && searchQuery.isNotEmpty) {
        url += '?search=$searchQuery';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['data'] ?? []);
      } else {
        throw Exception('Erreur lors du chargement des signalements');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  // Récupérer les signalements d'un utilisateur
  static Future<List<Map<String, dynamic>>> getUserSignalements(
      String userCode) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${ApiConfig.baseUrl}${ApiConfig.signalements}/user/$userCode'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['data'] ?? []);
      } else {
        throw Exception(
            'Erreur lors du chargement des signalements utilisateur');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  // Récupérer les signalements à proximité
  static Future<List<Map<String, dynamic>>> getNearbySignalements({
    required double lat,
    required double lng,
    int radius = 10,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${ApiConfig.baseUrl}${ApiConfig.signalementsNearby}?lat=$lat&lng=$lng&radius=$radius'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['data'] ?? []);
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

      if (files != null && files.isNotEmpty) {
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

  // Mettre à jour le statut
  static Future<bool> updateSignalementStatus(
      String code, String newStatus) async {
    try {
      final response = await http.patch(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.signalements}/$code/status'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'status': newStatus}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
