// lib/core/services/weather_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';

class WeatherService {
  static const String baseUrl =
      'http://localhost:3000'; // Changez selon votre API
  String? _authToken;

  WeatherService() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _authToken = prefs.getString('weather_api_token');
      if (kDebugMode) {
        print('Token chargé: ${_authToken != null ? 'Oui' : 'Non'}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur chargement token: $e');
      }
    }
  }

  Future<void> setToken(String token) async {
    _authToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('weather_api_token', token);
    if (kDebugMode) {
      print('Token sauvegardé');
    }
  }

  Future<void> clearToken() async {
    _authToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('weather_api_token');
    if (kDebugMode) {
      print('Token effacé');
    }
  }

  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (_authToken != null && _authToken!.isNotEmpty)
        'Authorization': 'Bearer $_authToken',
    };
  }

  bool get hasToken => _authToken != null && _authToken!.isNotEmpty;

  Future<WeatherResponse> getCurrentWeather() async {
    try {
      final uri = Uri.parse('$baseUrl/weather/current');
      if (kDebugMode) {
        print('GET $uri');
      }

      final response = await http.get(uri, headers: _getHeaders());

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherResponse.fromCurrentJson(data);
      } else if (response.statusCode == 401) {
        throw Exception('Token invalide ou expiré');
      } else {
        throw Exception('Erreur ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur getCurrentWeather: $e');
      }
      rethrow;
    }
  }

  Future<WeatherResponse> getForecast() async {
    try {
      final uri = Uri.parse('$baseUrl/weather/forecast');
      final response = await http.get(uri, headers: _getHeaders());

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherResponse.fromForecastJson(data);
      } else if (response.statusCode == 401) {
        throw Exception('Token invalide ou expiré');
      } else {
        throw Exception('Erreur ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  Future<void> simulateAlert({
    required String type,
    required String message,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/weather/simulate-alert'),
        headers: _getHeaders(),
        body: json.encode({
          'type': type,
          'message': message,
          'data': data ?? {},
        }),
      );

      if (response.statusCode == 401) {
        throw Exception('Token invalide ou expiré');
      } else if (response.statusCode != 200) {
        throw Exception('Erreur ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }
}
