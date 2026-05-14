enum UserRole {
  citizen('citoyen'),
  technician('technicien'),
  admin('administrateur');

  final String label;
  const UserRole(this.label);

  static UserRole fromString(String role) {
    switch (role.toLowerCase()) {
      case 'technicien':
        return UserRole.technician;
      case 'administrateur':
        return UserRole.admin;
      default:
        return UserRole.citizen;
    }
  }
}

class UserModel {
  final String id;
  final String nom;
  final String prenoms;
  final String numCIN;
  final DateTime dateCIN;
  final String lieuCIN;
  final String adresse;
  final UserRole role;
  final String codeUtilisateur;
  final String email;
  final String? phoneNumber;
  final String? profileImage;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastLogin;

  UserModel({
    required this.id,
    required this.nom,
    required this.prenoms,
    required this.numCIN,
    required this.dateCIN,
    required this.lieuCIN,
    required this.adresse,
    required this.role,
    required this.codeUtilisateur,
    required this.email,
    this.phoneNumber,
    this.profileImage,
    this.isActive = true,
    required this.createdAt,
    this.lastLogin,
  });

  String get fullName => '$prenoms $nom';
  String get initials => '${prenoms[0]}${nom[0]}'.toUpperCase();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['_id'] ?? '',
      nom: json['nom'] ?? '',
      prenoms: json['prenoms'] ?? '',
      numCIN: json['numCIN'] ?? '',
      dateCIN: DateTime.tryParse(json['dateCIN'] ?? '') ?? DateTime.now(),
      lieuCIN: json['lieuCIN'] ?? '',
      adresse: json['adresse'] ?? '',
      role: UserRole.fromString(json['role'] ?? 'citoyen'),
      codeUtilisateur: json['codeUtilisateur'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'],
      profileImage: json['profileImage'],
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      lastLogin: json['lastLogin'] != null
          ? DateTime.tryParse(json['lastLogin'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenoms': prenoms,
      'numCIN': numCIN,
      'dateCIN': dateCIN.toIso8601String(),
      'lieuCIN': lieuCIN,
      'adresse': adresse,
      'role': role.label,
      'codeUtilisateur': codeUtilisateur,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileImage': profileImage,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
    };
  }

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
      id: this.id,
      nom: nom ?? this.nom,
      prenoms: prenoms ?? this.prenoms,
      numCIN: this.numCIN,
      dateCIN: this.dateCIN,
      lieuCIN: this.lieuCIN,
      adresse: adresse ?? this.adresse,
      role: this.role,
      codeUtilisateur: this.codeUtilisateur,
      email: this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImage: profileImage ?? this.profileImage,
      isActive: isActive ?? this.isActive,
      createdAt: this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }
}
