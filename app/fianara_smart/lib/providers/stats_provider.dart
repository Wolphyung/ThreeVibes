// lib/core/providers/stats_provider.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatsProvider extends ChangeNotifier {
  // Données statistiques
  int _totalReports = 0;
  int _totalUsers = 0;
  int _resolutionRate = 0;
  int _avgResponseTime = 0;
  int _pendingReports = 0;
  int _completedReports = 0;
  int _rejectedReports = 0;

  // Données pour graphiques
  List<double> _reportsByMonth = [];
  List<Map<String, dynamic>> _reportsByCategory = [];
  List<Map<String, dynamic>> _reportsByStatus = [];
  List<dynamic> _recentReports = [];

  // Getters
  int get totalReports => _totalReports;
  int get totalUsers => _totalUsers;
  int get resolutionRate => _resolutionRate;
  int get avgResponseTime => _avgResponseTime;
  int get pendingReports => _pendingReports;
  int get completedReports => _completedReports;
  int get rejectedReports => _rejectedReports;
  List<double> get reportsByMonth => _reportsByMonth;
  List<Map<String, dynamic>> get reportsByCategory => _reportsByCategory;
  List<Map<String, dynamic>> get reportsByStatus => _reportsByStatus;
  List<dynamic> get recentReports => _recentReports;

  StatsProvider() {
    loadMockData();
  }

  void loadMockData() {
    // Statistiques générales
    _totalReports = 245;
    _totalUsers = 1240;
    _resolutionRate = 78;
    _avgResponseTime = 24;
    _pendingReports = 42;
    _completedReports = 198;
    _rejectedReports = 5;

    // Données mensuelles (12 mois)
    _reportsByMonth = [12, 19, 15, 22, 28, 35, 42, 38, 45, 52, 48, 55];

    // Répartition par catégorie
    _reportsByCategory = [
      {'category': 'Incendie', 'count': 45, 'color': 0xFFE53935},
      {'category': 'Infrastructure', 'count': 78, 'color': 0xFFFF9800},
      {'category': 'Environnement', 'count': 62, 'color': 0xFF4CAF50},
      {'category': 'Sécurité', 'count': 35, 'color': 0xFF2196F3},
      {'category': 'Autres', 'count': 25, 'color': 0xFF9C27B0},
    ];

    // Répartition par statut
    _reportsByStatus = [
      {'status': 'EN COURS', 'count': 42, 'color': 0xFFFF9800},
      {'status': 'TRAITÉ', 'count': 198, 'color': 0xFF4CAF50},
      {'status': 'REJETÉ', 'count': 5, 'color': 0xFFE53935},
    ];

    // Signalements récents
    _recentReports = [
      MockReport(
        id: '1',
        title: 'Incendie dans le quartier',
        description: 'Départ de feu dans un immeuble résidentiel',
        userName: 'Jean Dupont',
        userId: 'user_001',
        userAvatar: 'JD',
        location: 'Rue de la Liberté, Tunis',
        latitude: 36.8065,
        longitude: 10.1815,
        status: 'EN COURS',
        priority: 'URGENT',
        category: 'Incendie',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
        images: ['https://example.com/image1.jpg'],
        comments: 3,
      ),
      MockReport(
        id: '2',
        title: 'Fuite d\'eau importante',
        description: 'Canalisation principale cassée',
        userName: 'Marie Martin',
        userId: 'user_002',
        userAvatar: 'MM',
        location: 'Avenue Habib Bourguiba, Tunis',
        latitude: 36.8005,
        longitude: 10.1800,
        status: 'EN COURS',
        priority: 'ÉLEVÉ',
        category: 'Infrastructure',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 4)),
        images: [],
        comments: 2,
      ),
      MockReport(
        id: '3',
        title: 'Déchet sauvage',
        description: 'Dépôt illégal d\'ordures',
        userName: 'Ahmed Ben Ali',
        userId: 'user_003',
        userAvatar: 'AB',
        location: 'Cité Ettadhamen, Tunis',
        latitude: 36.7900,
        longitude: 10.1700,
        status: 'TRAITÉ',
        priority: 'NORMAL',
        category: 'Environnement',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
        images: ['https://example.com/image2.jpg'],
        comments: 5,
      ),
      MockReport(
        id: '4',
        title: 'Nid de poule dangereux',
        description: 'Trou profond sur la route principale',
        userName: 'Sophie Lefebvre',
        userId: 'user_004',
        userAvatar: 'SL',
        location: 'Route de La Marsa, Tunis',
        latitude: 36.8200,
        longitude: 10.1900,
        status: 'EN COURS',
        priority: 'ÉLEVÉ',
        category: 'Infrastructure',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        images: [],
        comments: 1,
      ),
      MockReport(
        id: '5',
        title: 'Stationnement illégal',
        description: 'Voitures garées sur le trottoir',
        userName: 'Karim Ben Salah',
        userId: 'user_005',
        userAvatar: 'KB',
        location: 'Centre-ville, Tunis',
        latitude: 36.8000,
        longitude: 10.1850,
        status: 'TRAITÉ',
        priority: 'NORMAL',
        category: 'Sécurité',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        images: ['https://example.com/image3.jpg'],
        comments: 0,
      ),
    ];

    notifyListeners();
  }

  Future<void> fetchAdminStats() async {
    // Simuler un appel API
    await Future.delayed(const Duration(seconds: 1));
    loadMockData();
  }

  // Méthodes pour mettre à jour les données
  void updateReportStatus(String reportId, String newStatus) {
    final report = _recentReports.firstWhere(
      (r) => r.id == reportId,
      orElse: () => null,
    );

    if (report != null) {
      report.status = newStatus;

      // Mettre à jour les compteurs
      _updateCounters();
      notifyListeners();
    }
  }

  void addReport(dynamic newReport) {
    _recentReports.insert(0, newReport);
    _totalReports++;
    _pendingReports++;
    _updateCounters();
    notifyListeners();
  }

  void deleteReport(String reportId) {
    _recentReports.removeWhere((r) => r.id == reportId);
    _updateCounters();
    notifyListeners();
  }

  void _updateCounters() {
    _pendingReports =
        _recentReports.where((r) => r.status == 'EN COURS').length;
    _completedReports =
        _recentReports.where((r) => r.status == 'TRAITÉ').length;
    _rejectedReports = _recentReports.where((r) => r.status == 'REJETÉ').length;
    _totalReports = _recentReports.length;
    _resolutionRate = _totalReports > 0
        ? (_completedReports * 100 / _totalReports).round()
        : 0;
  }

  // Méthodes pour les filtres et recherches
  List<dynamic> getReportsByStatus(String status) {
    if (status == 'Tous') {
      return _recentReports;
    }
    return _recentReports.where((r) => r.status == status).toList();
  }

  List<dynamic> getReportsByPriority(String priority) {
    if (priority == 'Tous') {
      return _recentReports;
    }
    return _recentReports.where((r) => r.priority == priority).toList();
  }

  List<dynamic> getReportsByCategory(String category) {
    if (category == 'Tous') {
      return _recentReports;
    }
    return _recentReports.where((r) => r.category == category).toList();
  }

  List<dynamic> searchReports(String query) {
    if (query.isEmpty) {
      return _recentReports;
    }

    return _recentReports.where((r) {
      return r.title.toLowerCase().contains(query.toLowerCase()) ||
          r.location.toLowerCase().contains(query.toLowerCase()) ||
          r.userName.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Statistiques pour le dashboard
  Map<String, dynamic> getWeeklyStats() {
    final now = DateTime.now();
    final weekDays = List.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      return {
        'day': _getDayName(date.weekday),
        'count': _reportsByMonth[date.day % 12],
        'date': date,
      };
    });
    return {
      'labels': weekDays.map((d) => d['day']).toList(),
      'data': weekDays.map((d) => d['count']).toList()
    };
  }

  String _getDayName(int weekday) {
    const days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    return days[weekday - 1];
  }

  // Tendance des signalements (pourcentage d'augmentation)
  double getReportTrend() {
    final lastMonth = _reportsByMonth[_reportsByMonth.length - 1];
    final previousMonth = _reportsByMonth[_reportsByMonth.length - 2];
    if (previousMonth == 0) return 0;
    return ((lastMonth - previousMonth) / previousMonth) * 100;
  }

  // Temps de réponse moyen en heures
  int getAverageResponseTime() {
    return _avgResponseTime;
  }

  // Taux de satisfaction (simulé)
  int getSatisfactionRate() {
    return 85; // 85% de satisfaction
  }
}

// Modèle MockReport
class MockReport {
  final String id;
  final String title;
  final String description;
  final String userName;
  final String userId;
  final String userAvatar;
  final String location;
  final double latitude;
  final double longitude;
  String status;
  final String priority;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> images;
  final int comments;

  MockReport({
    required this.id,
    required this.title,
    required this.description,
    required this.userName,
    required this.userId,
    required this.userAvatar,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.priority,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    required this.images,
    required this.comments,
  });
}

// Extension pour faciliter l'utilisation
extension StatsProviderExtension on BuildContext {
  StatsProvider get statsProvider => Provider.of<StatsProvider>(this);
  StatsProvider get statsProviderListen =>
      Provider.of<StatsProvider>(this, listen: true);
}
