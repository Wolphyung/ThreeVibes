// lib/services/annonce_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../core/api_config.dart';

class AnnonceService {
  // Récupérer toutes les annonces
  static Future<List<dynamic>> getAllAnnonces({String? searchQuery}) async {
    try {
      String url = '${ApiConfig.baseUrl}${ApiConfig.annonces}';
      if (searchQuery != null && searchQuery.isNotEmpty) {
        url += '?q=$searchQuery';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erreur lors du chargement des annonces');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  // Créer une annonce
  static Future<Map<String, dynamic>> createAnnonce({
    required double latitude,
    required double longitude,
    required String codeCategorie,
    required String contenu,
    List<File>? files,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.annonces}'),
      );

      request.fields['latitude'] = latitude.toString();
      request.fields['longitude'] = longitude.toString();
      request.fields['codeCategorie'] = codeCategorie;
      request.fields['contenu'] = contenu;

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
          'error': 'Erreur lors de la création',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Erreur: $e',
      };
    }
  }

  // Créer une annonce avec demande
  static Future<Map<String, dynamic>> createAnnonceWithDemande({
    required double latitude,
    required double longitude,
    required String codeCategorie,
    required String codeUtilisateur,
    required String contenu,
    List<File>? files,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.annoncesWithDemande}'),
      );

      request.fields['latitude'] = latitude.toString();
      request.fields['longitude'] = longitude.toString();
      request.fields['codeCategorie'] = codeCategorie;
      request.fields['codeUtilisateur'] = codeUtilisateur;
      request.fields['contenu'] = contenu;

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
          'error': 'Erreur lors de la création',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Erreur: $e',
      };
    }
  }
}
