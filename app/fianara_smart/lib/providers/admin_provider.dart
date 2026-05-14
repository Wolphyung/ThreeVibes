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
