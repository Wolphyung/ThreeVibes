// lib/core/api_config.dart
class ApiConfig {
  static const String baseUrl = 'https://threevibes.onrender.com/api';

  // Endpoints Utilisateurs
  static const String register = '/users/register';
  static const String login = '/users/login';
  static const String updateUser = '/users/';
  static const String deleteUser = '/users/';
  static const String forgotPassword = '/users/forgot-password';

  // Endpoints Annonces
  static const String annonces = '/annonces';
  static const String annoncesWithDemande = '/annonces/create-with-demande';
  static const String categories = '/annonces/categories';
  static const String demandes = '/annonces/demandes';

  // Endpoints Signalements
  static const String signalements = '/signalements';
  static const String signalementsNearby = '/signalements/nearby';
  static const String signalementsByFonction = '/signalements/by-fonction';

  // Endpoints Pièces Jointes
  static const String uploadFile = '/piece-jointe/upload';
  static const String uploadMultipleFiles = '/piece-jointe/upload-multiple';

  // Endpoints Météo
  static const String currentWeather = '/weather/current';
  static const String forecastWeather = '/weather/forecast';
}
