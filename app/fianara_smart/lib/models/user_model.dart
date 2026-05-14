// lib/models/user_model.dart
enum UserRole {
  admin,
  technicien,
  citoyen,
}

class UserModel {
  final String id;
  final String codeUtilisateur;
  final String nom;
  final String prenoms;
  final String numCIN;
  final DateTime dateCIN;
  final String lieuCIN;
  final String adresse;
  final UserRole role;
  final String email;
  final String? phoneNumber;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;
  final String? token;

  UserModel({
    required this.id,
    required this.codeUtilisateur,
    required this.nom,
    required this.prenoms,
    required this.numCIN,
    required this.dateCIN,
    required this.lieuCIN,
    required this.adresse,
    required this.role,
    required this.email,
    this.phoneNumber,
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
    this.token,
  });

  String get fullName => '$nom $prenoms';

  String get initials {
    final nomInitial = nom.isNotEmpty ? nom[0] : '';
    final prenomInitial = prenoms.isNotEmpty ? prenoms[0] : '';
    return '$nomInitial$prenomInitial'.toUpperCase();
  }

  String get roleString {
    switch (role) {
      case UserRole.admin:
        return 'ADMIN';
      case UserRole.technicien:
        return 'TECHNICIEN';
      case UserRole.citoyen:
        return 'CITOYEN';
    }
  }

  bool get isNew {
    final now = DateTime.now();
    final diff = now.difference(createdAt).inDays;
    return diff <= 30;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      codeUtilisateur:
          json['codeUtilisateur']?.toString() ?? json['id']?.toString() ?? '',
      nom: json['nom']?.toString() ?? '',
      prenoms: json['prenoms']?.toString() ?? '',
      numCIN: json['numCIN']?.toString() ?? '',
      dateCIN: json['dateCIN'] != null
          ? DateTime.tryParse(json['dateCIN'].toString()) ?? DateTime.now()
          : DateTime.now(),
      lieuCIN: json['lieuCIN']?.toString() ?? '',
      adresse: json['adresse']?.toString() ?? '',
      role: _parseRole(json['role']?.toString() ?? 'CITOYEN'),
      email: json['email']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      isActive: json['isActive'] ?? true,
      token: json['token']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'prenoms': prenoms,
      'numCIN': numCIN,
      'dateCIN': dateCIN.toIso8601String().split('T')[0],
      'lieuCIN': lieuCIN,
      'adresse': adresse,
      'role': roleString,
      'email': email,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
    };
  }

<<<<<<< HEAD
  UserModel copyWith({
    String? nom,
    String? prenoms,
    String? adresse,
    String? phoneNumber,
    String? profileImage,
    bool? isActive,
    DateTime? lastLogin,
  }) {
    return UserModel(
      id: id,
      nom: nom ?? this.nom,
      prenoms: prenoms ?? this.prenoms,
      numCIN: numCIN,
      dateCIN: dateCIN,
      lieuCIN: lieuCIN,
      adresse: adresse ?? this.adresse,
      role: role,
      codeUtilisateur: codeUtilisateur,
      email: email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImage: profileImage ?? this.profileImage,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
=======
  static UserRole _parseRole(String role) {
    switch (role.toUpperCase()) {
      case 'ADMIN':
        return UserRole.admin;
      case 'TECHNICIEN':
        return UserRole.technicien;
      case 'CITOYEN':
        return UserRole.citoyen;
      default:
        return UserRole.citoyen;
    }
>>>>>>> ab5b510b0e5d51fbce79c225479cea42f1147e5b
  }
}
