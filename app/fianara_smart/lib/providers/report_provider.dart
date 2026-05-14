import 'package:flutter/material.dart';
import '../models/report_model.dart';
import '../models/user_model.dart';

class ReportProvider extends ChangeNotifier {
  List<ReportModel> _reports = [];
  bool _isLoading = false;
  String? _error;

  List<ReportModel> get reports => _reports;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Ajouter cette propriété
  bool get isAdmin {
    // Pour l'instant retourne false, plus tard on pourra vérifier le rôle
    return false;
  }

  Future<void> fetchReports() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      _reports = [
        ReportModel(
          id: '1',
          title: 'Déchets sur la voie publique',
          description: 'Accumulation de déchets devant le marché',
          type: ReportType.waste,
          status: ReportStatus.pending,
          latitude: -21.4330,
          longitude: 47.0855,
          locationAddress: 'Marché couvert, Fianarantsoa',
          reportedBy: UserModel(
            id: 'user1',
            nom: 'RAKOTO',
            prenoms: 'Jean',
            numCIN: '10123456789',
            dateCIN: DateTime.now(),
            lieuCIN: 'Fianarantsoa',
            adresse: 'Ambatovolo',
            role: UserRole.citoyen,
            codeUtilisateur: 'CIT001',
            email: 'jean@email.com',
            createdAt: DateTime.now(),
          ),
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        ReportModel(
          id: '2',
          title: 'Problème d\'éclairage',
          description: 'Lampadaire cassé rue principale',
          type: ReportType.lighting,
          status: ReportStatus.inProgress,
          latitude: -21.4320,
          longitude: 47.0845,
          locationAddress: 'Rue principale, Fianarantsoa',
          reportedBy: UserModel(
            id: 'user2',
            nom: 'RASOA',
            prenoms: 'Marie',
            numCIN: '10123456790',
            dateCIN: DateTime.now(),
            lieuCIN: 'Fianarantsoa',
            adresse: 'Andrainjato',
            role: UserRole.citoyen,
            codeUtilisateur: 'CIT002',
            email: 'marie@email.com',
            createdAt: DateTime.now(),
          ),
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addReport(ReportModel report) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));
    _reports.insert(0, report);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateReportStatus(
      String reportId, ReportStatus newStatus) async {
    final index = _reports.indexWhere((r) => r.id == reportId);
    if (index != -1) {
      final oldReport = _reports[index];
      _reports[index] = ReportModel(
        id: oldReport.id,
        title: oldReport.title,
        description: oldReport.description,
        type: oldReport.type,
        status: newStatus,
        latitude: oldReport.latitude,
        longitude: oldReport.longitude,
        locationAddress: oldReport.locationAddress,
        reportedBy: oldReport.reportedBy,
        createdAt: oldReport.createdAt,
        resolvedAt: newStatus == ReportStatus.resolved
            ? DateTime.now()
            : oldReport.resolvedAt,
      );
      notifyListeners();
    }
  }
}
