<<<<<<< HEAD
// lib/features/admin/models/signalement_model.dart
=======
>>>>>>> ad647aa55ee6cea1612beb10935f79bf917b2910
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
<<<<<<< HEAD
      code: json['codesignalement']?.toString() ?? '',
      type: json['typesignalement']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      dateSignalement: json['datesignalement'] != null
          ? DateTime.parse(json['datesignalement'].toString())
=======
      code: json['code'] ?? json['codeSignalement'] ?? '',
      type: json['typeSignalement'] ?? json['type'] ?? '',
      description: json['description'] ?? '',
      dateSignalement: json['dateSignalement'] != null
          ? DateTime.parse(json['dateSignalement'])
>>>>>>> ad647aa55ee6cea1612beb10935f79bf917b2910
          : DateTime.now(),
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      codeUtilisateur: json['codeutilisateur']?.toString() ?? '',
      fonctions: List<String>.from(json['fonctions'] ?? []),
<<<<<<< HEAD
      status: json['status']?.toString() ?? 'EN COURS',
      priorite: json['priorite']?.toString() ?? 'NORMAL',
      images: imageUrls,
=======
      status: json['status'] ?? 'EN ATTENTE',
      priorite: json['priorite'] ?? 'NORMAL',
>>>>>>> ad647aa55ee6cea1612beb10935f79bf917b2910
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'type': type,
      'description': description,
      'dateSignalement': dateSignalement.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'codeUtilisateur': codeUtilisateur,
      'fonctions': fonctions,
      'status': status,
      'priorite': priorite,
    };
  }

  // Getter pour la date formatée (ex: "15/05/2024 à 14:30")
  String get formattedDate {
    return '${dateSignalement.day}/${dateSignalement.month}/${dateSignalement.year} à ${dateSignalement.hour}:${dateSignalement.minute.toString().padLeft(2, '0')}';
  }

  // Getter pour le temps écoulé (ex: "Il y a 2 heures", "Il y a 3 jours")
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(dateSignalement);

    if (difference.inDays > 7) {
      return formattedDate;
    } else if (difference.inDays > 0) {
      return 'Il y a ${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'Il y a ${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'Il y a ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'À l\'instant';
    }
  }

  // Getter pour le temps court (ex: "2j", "3h", "15min")
  String get timeAgoShort {
    final now = DateTime.now();
    final difference = now.difference(dateSignalement);

    if (difference.inDays > 0) {
      return '${difference.inDays}j';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}min';
    } else {
      return 'maintenant';
    }
  }

  // Getter pour le numéro de référence formaté
  String get refNumber {
    return 'REF-${code.padLeft(4, '0')}';
  }

  // Getter pour savoir si le signalement est récent (moins de 24h)
  bool get isRecent {
    final now = DateTime.now();
    final difference = now.difference(dateSignalement);
    return difference.inHours < 24;
  }

  // Getter pour savoir si le signalement est urgent
  bool get isUrgent {
    return priorite.toUpperCase() == 'URGENT';
  }

  // Getter pour savoir si le signalement est en cours
  bool get isInProgress {
    return status == 'EN COURS';
  }

  // Getter pour savoir si le signalement est traité
  bool get isResolved {
    return status == 'TRAITÉ';
  }

  // Getter pour savoir si le signalement est rejeté
  bool get isRejected {
    return status == 'REJETÉ';
  }
}
