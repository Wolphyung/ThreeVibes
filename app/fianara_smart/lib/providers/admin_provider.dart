// lib/providers/admin_provider.dart
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AdminProvider extends ChangeNotifier {
  List<UserModel> _users = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<UserModel> get users => _users;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get totalUsers => _users.length;
  int get activeUsers => _users.where((u) => u.isActive).length;
  int get inactiveUsers => _users.where((u) => !u.isActive).length;

  AdminProvider() {
    loadMockUsers();
  }

  void loadMockUsers() {
    _users = [
      UserModel(
        id: '1',
        codeUtilisateur: 'U001',
        nom: 'Dupont',
        prenoms: 'Jean',
        numCIN: '123456789',
        dateCIN: DateTime.now(),
        lieuCIN: 'Antananarivo',
        adresse: '123 Rue Principale',
        role: UserRole.citoyen,
        email: 'jean@example.com',
        phoneNumber: '0341234567',
        createdAt: DateTime.now(),
        isActive: true,
      ),
      UserModel(
        id: '2',
        codeUtilisateur: 'U002',
        nom: 'Martin',
        prenoms: 'Marie',
        numCIN: '987654321',
        dateCIN: DateTime.now(),
        lieuCIN: 'Antananarivo',
        adresse: '456 Avenue Centrale',
        role: UserRole.technicien,
        email: 'marie@example.com',
        phoneNumber: '0347654321',
        createdAt: DateTime.now(),
        isActive: true,
      ),
      UserModel(
        id: '3',
        codeUtilisateur: 'U003',
        nom: 'Admin',
        prenoms: 'System',
        numCIN: 'ADMIN001',
        dateCIN: DateTime.now(),
        lieuCIN: 'Antananarivo',
        adresse: 'Mairie',
        role: UserRole.admin,
        email: 'admin@example.com',
        phoneNumber: '0340000000',
        createdAt: DateTime.now(),
        isActive: true,
      ),
    ];
    notifyListeners();
  }

  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));
    loadMockUsers();

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateUserStatus(String userId, bool isActive) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

<<<<<<< HEAD
  List<AdminActivity> _getMockActivities() {
    return [
      AdminActivity(
        id: '1',
        action: 'Connexion au système',
        details: 'Admin connecté depuis Chrome sur Windows',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        type: ActivityType.login,
      ),
      AdminActivity(
        id: '2',
        action: 'Signalement modéré',
        details: 'Signalement #INC-2024-001 marqué comme traité',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        type: ActivityType.moderation,
      ),
      AdminActivity(
        id: '3',
        action: 'Nouvelle annonce publiée',
        details: 'Annonce: "Coupure d\'eau programmée"',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        type: ActivityType.announcement,
      ),
      AdminActivity(
        id: '4',
        action: 'Utilisateur désactivé',
        details: 'Compte utilisateur #USR-2024-089 désactivé',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: ActivityType.userManagement,
      ),
      AdminActivity(
        id: '5',
        action: 'Export des données',
        details: 'Export des signalements du mois de décembre',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        type: ActivityType.export,
      ),
    ];
  }

  List<AdminNotification> _getMockNotifications() {
    return [
      AdminNotification(
        id: '1',
        title: 'Nouveau signalement urgent',
        message: 'Un signalement de type "Incendie" a été signalé comme urgent',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isRead: false,
        type: NotificationType.urgent,
        actionId: 'report_123',
      ),
      AdminNotification(
        id: '2',
        title: 'Rapport hebdomadaire',
        message: 'Consultez le rapport des activités de la semaine',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        isRead: false,
        type: NotificationType.info,
        actionId: 'report_weekly',
      ),
      AdminNotification(
        id: '3',
        title: 'Maintenance planifiée',
        message: 'Le système sera en maintenance le 25/12 de 2h à 4h',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
        type: NotificationType.warning,
        actionId: null,
      ),
      AdminNotification(
        id: '4',
        title: 'Nouvel utilisateur inscrit',
        message: 'Bienvenue à notre 1000ème utilisateur !',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
        type: NotificationType.success,
        actionId: 'user_1000',
      ),
    ];
  }

  List<AdminPermission> _getMockPermissions() {
    return [
      AdminPermission(
          name: 'manage_reports',
          isGranted: true,
          description: 'Gérer les signalements'),
      AdminPermission(
          name: 'manage_users',
          isGranted: true,
          description: 'Gérer les utilisateurs'),
      AdminPermission(
          name: 'manage_announcements',
          isGranted: true,
          description: 'Gérer les annonces'),
      AdminPermission(
          name: 'manage_admins',
          isGranted: true,
          description: 'Gérer les administrateurs'),
      AdminPermission(
          name: 'view_stats',
          isGranted: true,
          description: 'Voir les statistiques'),
      AdminPermission(
          name: 'export_data',
          isGranted: true,
          description: 'Exporter les données'),
      AdminPermission(
          name: 'delete_reports',
          isGranted: false,
          description: 'Supprimer définitivement'),
      AdminPermission(
          name: 'ban_users',
          isGranted: true,
          description: 'Bannir des utilisateurs'),
    ];
  }

  AdminStats _getMockAdminStats() {
    return AdminStats(
      actionsToday: 24,
      actionsThisWeek: 156,
      reportsModerated: 245,
      usersManaged: 89,
      announcementsPublished: 12,
      avgResponseTime: 2.5,
      satisfactionRate: 92,
    );
  }
}

// Modèles de données
class AdminProfile {
  final String id;
  String name;
  String email;
  String? phone;
  String department;
  final String role;
  String? bio;
  final String? avatarUrl;
  final DateTime joinedAt;
  DateTime lastLogin;
  bool isActive;

  AdminProfile({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.department,
    required this.role,
    this.bio,
    this.avatarUrl,
    required this.joinedAt,
    required this.lastLogin,
    required this.isActive,
  });

  AdminProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? department,
    String? bio,
    DateTime? lastLogin,
    bool? isActive,
  }) {
    return AdminProfile(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      department: department ?? this.department,
      role: role,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl,
      joinedAt: joinedAt,
      lastLogin: lastLogin ?? this.lastLogin,
      isActive: isActive ?? this.isActive,
    );
  }
}

class AdminActivity {
  final String id;
  final String action;
  final String details;
  final DateTime timestamp;
  final ActivityType type;

  AdminActivity({
    required this.id,
    required this.action,
    required this.details,
    required this.timestamp,
    required this.type,
  });

  String get icon {
    switch (type) {
      case ActivityType.login:
        return '🔐';
      case ActivityType.moderation:
        return '📋';
      case ActivityType.announcement:
        return '📢';
      case ActivityType.userManagement:
        return '👥';
      case ActivityType.export:
        return '📊';
      default:
        return '📌';
=======
    final index = _users.indexWhere((u) => u.id == userId);
    if (index != -1) {
      final oldUser = _users[index];
      _users[index] = UserModel(
        id: oldUser.id,
        codeUtilisateur: oldUser.codeUtilisateur,
        nom: oldUser.nom,
        prenoms: oldUser.prenoms,
        numCIN: oldUser.numCIN,
        dateCIN: oldUser.dateCIN,
        lieuCIN: oldUser.lieuCIN,
        adresse: oldUser.adresse,
        role: oldUser.role,
        email: oldUser.email,
        phoneNumber: oldUser.phoneNumber,
        createdAt: oldUser.createdAt,
        isActive: isActive,
      );
      _isLoading = false;
      notifyListeners();
      return true;
>>>>>>> ab5b510b0e5d51fbce79c225479cea42f1147e5b
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Méthode pour obtenir la couleur du rôle (sans switch avec default inutile)
  Color getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Colors.red;
      case UserRole.technicien:
        return Colors.orange;
      case UserRole.citoyen:
        return Colors.blue;
    }
  }

  // Méthode pour obtenir le texte du rôle
  String getRoleString(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'Administrateur';
      case UserRole.technicien:
        return 'Technicien';
      case UserRole.citoyen:
        return 'Citoyen';
    }
  }

  // Méthode pour obtenir la couleur du statut
  Color getStatusColor(bool isActive) {
    return isActive ? Colors.green : Colors.grey;
  }

  // Méthode pour obtenir le texte du statut
  String getStatusString(bool isActive) {
    return isActive ? 'Actif' : 'Inactif';
  }

  // Supprimez les méthodes suivantes si elles existent avec des switch problématiques :
  // - statusColor (remplacé par getStatusColor)
  // - statusIcon (si vous l'utilisez)
  // - priorityColor (si vous l'utilisez)
}

// Si vous avez une classe AdminStats, assurez-vous qu'elle est correcte
class AdminStats {
  final int totalUsers;
  final int activeUsers;
  final int totalReports;
  final int pendingReports;
  final int resolvedReports;
  final double resolutionRate;

  AdminStats({
    required this.totalUsers,
    required this.activeUsers,
    required this.totalReports,
    required this.pendingReports,
    required this.resolvedReports,
    required this.resolutionRate,
  });
}
