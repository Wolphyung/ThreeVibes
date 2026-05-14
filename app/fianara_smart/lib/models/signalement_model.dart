// lib/models/signalement_model.dart
class SignalementModel {
  final String code;
  final String type;
  final String description;
  final DateTime dateSignalement;
  final double latitude;
  final double longitude;
  final String codeUtilisateur;
  final List<String> fonctions;
  final String status;
  final String priorite;

  SignalementModel({
    required this.code,
    required this.type,
    required this.description,
    required this.dateSignalement,
    required this.latitude,
    required this.longitude,
    required this.codeUtilisateur,
    required this.fonctions,
    required this.status,
    required this.priorite,
  });

  factory SignalementModel.fromJson(Map<String, dynamic> json) {
    return SignalementModel(
      code: json['code'] ?? json['codeSignalement'] ?? '',
      type: json['typeSignalement'] ?? '',
      description: json['description'] ?? '',
      dateSignalement: json['dateSignalement'] != null
          ? DateTime.parse(json['dateSignalement'])
          : DateTime.now(),
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      codeUtilisateur: json['codeUtilisateur'] ?? '',
      fonctions: List<String>.from(json['fonctions'] ?? []),
      status: json['status'] ?? 'EN COURS',
      priorite: json['priorite'] ?? 'NORMAL',
    );
  }
}
