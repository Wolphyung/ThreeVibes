// lib/services/instruction_dossier_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import '../models/instruction_dossier_model.dart';

class InstructionDossierService {
  static Future<List<InstructionDossier>> getAll() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.instructionDossiers}'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['dossiers'] ?? [];
        return data.map((item) => InstructionDossier.fromJson(item)).toList();
      } else {
        throw Exception('Erreur serveur (${response.statusCode})');
      }
    } catch (e) {
      print('InstructionDossierService.getAll Error: $e');
      rethrow;
    }
  }

  static Future<InstructionDossier> create(InstructionDossier dossier) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.instructionDossiers}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(dossier.toJson()),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        return InstructionDossier.fromJson(data['dossier']);
      } else {
        throw Exception('Erreur serveur (${response.statusCode})');
      }
    } catch (e) {
      print('InstructionDossierService.create Error: $e');
      rethrow;
    }
  }

  static Future<InstructionDossier> update(String id, InstructionDossier dossier) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.instructionDossiers}/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(dossier.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return InstructionDossier.fromJson(data['dossier']);
      } else {
        throw Exception('Erreur serveur (${response.statusCode})');
      }
    } catch (e) {
      print('InstructionDossierService.update Error: $e');
      rethrow;
    }
  }

  static Future<void> delete(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.instructionDossiers}/$id'),
      );

      if (response.statusCode != 200) {
        throw Exception('Erreur serveur (${response.statusCode})');
      }
    } catch (e) {
      print('InstructionDossierService.delete Error: $e');
      rethrow;
    }
  }
}
