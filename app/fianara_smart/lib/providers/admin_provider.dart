// lib/core/providers/admin_provider.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminProvider extends ChangeNotifier {
  // État de l'admin
  bool _isLoading = false;
  String? _errorMessage;

  // Données admin
  AdminProfile? _adminProfile;
  List<AdminActivity> _recentActivities = [];
  List<AdminNotification> _notifications = [];
  List<AdminPermission> _permissions = [];

  // Statistiques admin
  AdminStats? _adminStats;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AdminProfile? get adminProfile => _adminProfile;
  List<AdminActivity> get recentActivities => _recentActivities;
  List<AdminNotification> get notifications => _notifications;
  List<AdminPermission> get permissions => _permissions;
  AdminStats? get adminStats => _adminStats;
  int get unreadNotificationsCount =>
      _notifications.where((n) => !n.isRead).length;

  AdminProvider() {
    loadAdminData();
  }

  // Charger toutes les données admin
  Future<void> loadAdminData() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      // Simuler un appel API
      await Future.delayed(const Duration(milliseconds: 500));

      _adminProfile = _getMockAdminProfile();
      _recentActivities = _getMockActivities();
      _notifications = _getMockNotifications();
      _permissions = _getMockPermissions();
      _adminStats = _getMockAdminStats();

      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
    }
  }

  // Mettre à jour le profil admin
  Future<bool> updateAdminProfile({
    String? name,
    String? email,
    String? phone,
    String? department,
    String? bio,
  }) async {
    _setLoading(true);

    try {
      // Simuler un appel API
      await Future.delayed(const Duration(seconds: 1));

      if (_adminProfile != null) {
        _adminProfile = _adminProfile!.copyWith(
          name: name,
          email: email,
          phone: phone,
          department: department,
          bio: bio,
        );
      }

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // Changer le mot de passe
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    _setLoading(true);

    try {
      // Simuler un appel API
      await Future.delayed(const Duration(seconds: 1));

      if (newPassword != confirmPassword) {
        _errorMessage = "Les mots de passe ne correspondent pas";
        _setLoading(false);
        return false;
      }

      if (currentPassword != "admin123") {
        // Mock validation
        _errorMessage = "Mot de passe actuel incorrect";
        _setLoading(false);
        return false;
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // Marquer une notification comme lue
  void markNotificationAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  // Marquer toutes les notifications comme lues
  void markAllNotificationsAsRead() {
    for (var notification in _notifications) {
      notification.isRead = true;
    }
    notifyListeners();
  }

  // Supprimer une notification
  void deleteNotification(String notificationId) {
    _notifications.removeWhere((n) => n.id == notificationId);
    notifyListeners();
  }

  // Ajouter une activité récente
  void addActivity(AdminActivity activity) {
    _recentActivities.insert(0, activity);
    if (_recentActivities.length > 20) {
      _recentActivities.removeLast();
    }
    notifyListeners();
  }

  // Vérifier si l'admin a une permission
  bool hasPermission(String permissionName) {
    return _permissions.any((p) => p.name == permissionName && p.isGranted);
  }

  // Mettre à jour les statistiques
  Future<void> refreshStats() async {
    _setLoading(true);
    await Future.delayed(const Duration(seconds: 1));
    _adminStats = _getMockAdminStats();
    _setLoading(false);
    notifyListeners();
  }

  // Actions admin (modération, gestion, etc.)
  Future<bool> moderateReport(
      String reportId, String action, String? reason) async {
    _setLoading(true);

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      // Logique de modération
      addActivity(AdminActivity(
        id: DateTime.now().toString(),
        action: "Modération du signalement #$reportId",
        details: "Action: $action${reason != null ? ', Raison: $reason' : ''}",
        timestamp: DateTime.now(),
        type: ActivityType.moderation,
      ));

      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> manageUser(String userId, String action) async {
    _setLoading(true);

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      addActivity(AdminActivity(
        id: DateTime.now().toString(),
        action: "Gestion utilisateur #$userId",
        details: "Action: $action",
        timestamp: DateTime.now(),
        type: ActivityType.userManagement,
      ));

      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> publishAnnouncement(
      String title, String content, String priority) async {
    _setLoading(true);

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      addActivity(AdminActivity(
        id: DateTime.now().toString(),
        action: "Publication d'annonce",
        details: "Titre: $title, Priorité: $priority",
        timestamp: DateTime.now(),
        type: ActivityType.announcement,
      ));

      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // Méthodes privées
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Données mock
  AdminProfile _getMockAdminProfile() {
    return AdminProfile(
      id: 'admin_001',
      name: 'Admin Système',
      email: 'admin@fianara.com',
      phone: '+216 12 345 678',
      department: 'Sécurité Publique',
      role: 'Super Administrateur',
      bio: 'Administrateur principal du système de signalement citoyen',
      avatarUrl: null,
      joinedAt: DateTime(2024, 1, 15),
      lastLogin: DateTime.now(),
      isActive: true,
    );
  }

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
    }
  }

  Color get color {
    switch (type) {
      case ActivityType.login:
        return Colors.blue;
      case ActivityType.moderation:
        return Colors.orange;
      case ActivityType.announcement:
        return Colors.green;
      case ActivityType.userManagement:
        return Colors.purple;
      case ActivityType.export:
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}

class AdminNotification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  bool isRead;
  final NotificationType type;
  final String? actionId;

  AdminNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.isRead,
    required this.type,
    this.actionId,
  });

  Color get color {
    switch (type) {
      case NotificationType.urgent:
        return Colors.red;
      case NotificationType.warning:
        return Colors.orange;
      case NotificationType.success:
        return Colors.green;
      case NotificationType.info:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData get icon {
    switch (type) {
      case NotificationType.urgent:
        return Icons.warning;
      case NotificationType.warning:
        return Icons.info;
      case NotificationType.success:
        return Icons.check_circle;
      case NotificationType.info:
        return Icons.notifications;
      default:
        return Icons.notifications_none;
    }
  }
}

class AdminPermission {
  final String name;
  bool isGranted;
  final String description;

  AdminPermission({
    required this.name,
    required this.isGranted,
    required this.description,
  });
}

class AdminStats {
  final int actionsToday;
  final int actionsThisWeek;
  final int reportsModerated;
  final int usersManaged;
  final int announcementsPublished;
  final double avgResponseTime;
  final int satisfactionRate;

  AdminStats({
    required this.actionsToday,
    required this.actionsThisWeek,
    required this.reportsModerated,
    required this.usersManaged,
    required this.announcementsPublished,
    required this.avgResponseTime,
    required this.satisfactionRate,
  });
}

enum ActivityType {
  login,
  moderation,
  announcement,
  userManagement,
  export,
}

enum NotificationType {
  urgent,
  warning,
  success,
  info,
}

// Extension pour faciliter l'utilisation
extension AdminProviderExtension on BuildContext {
  AdminProvider get adminProvider => Provider.of<AdminProvider>(this);
  AdminProvider get adminProviderListen =>
      Provider.of<AdminProvider>(this, listen: true);
}
