// lib/features/admin/models/signalement_model.dart
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
  final List<String> images; // Ajout du champ images

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
    this.images = const [], // Valeur par défaut
  });

  factory SignalementModel.fromJson(Map<String, dynamic> json) {
    // Récupérer les images depuis PJ (Piece Jointe)
    List<String> imageUrls = [];
    if (json['PJ'] != null && json['PJ'] is List) {
      imageUrls = (json['PJ'] as List)
          .map((pj) => pj['lien']?.toString() ?? '')
          .where((url) => url.isNotEmpty)
          .toList();
    }

    return SignalementModel(
      code: json['codesignalement']?.toString() ?? '',
      type: json['typesignalement']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      dateSignalement: json['datesignalement'] != null
          ? DateTime.parse(json['datesignalement'].toString())
          : DateTime.now(),
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      codeUtilisateur: json['codeutilisateur']?.toString() ?? '',
      fonctions: List<String>.from(json['fonctions'] ?? []),
      status: json['status']?.toString() ?? 'EN COURS',
      priorite: json['priorite']?.toString() ?? 'NORMAL',
      images: imageUrls,
    );
  }
}
