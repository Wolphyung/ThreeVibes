// lib/services/chat_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';

class ChatService {
  static Future<Map<String, dynamic>> sendMessage(String message, {String? codedossier}) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.chatbotChat}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'message': message,
          if (codedossier != null) 'codedossier': codedossier,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erreur serveur (${response.statusCode})');
      }
    } catch (e) {
      print('ChatService Error: $e');
      rethrow;
    }
  }
}
