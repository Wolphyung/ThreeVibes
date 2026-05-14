import 'package:flutter/material.dart';
import '../models/announcement_model.dart';
import '../models/user_model.dart';

class AnnouncementProvider extends ChangeNotifier {
  List<AnnouncementModel> _announcements = [];
  bool _isLoading = false;

  List<AnnouncementModel> get announcements => _announcements;
  bool get isLoading => _isLoading;

  Future<void> fetchAnnouncements() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _announcements = [
      AnnouncementModel(
        id: '1',
        title: 'Nouvelle fonctionnalité de signalement',
        content:
            'Vous pouvez maintenant signaler les problèmes directement avec photo.',
        publishedBy: UserModel(
          id: 'admin1',
          nom: 'ADMIN',
          prenoms: 'System',
          numCIN: 'ADMIN001',
          dateCIN: DateTime.now(),
          lieuCIN: 'Fianarantsoa',
          adresse: 'Mairie',
          role: UserRole.admin,
          codeUtilisateur: 'ADM001',
          email: 'admin@fianara.com',
          createdAt: DateTime.now(),
        ),
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
        isUrgent: false,
      ),
      AnnouncementModel(
        id: '2',
        title: 'Travaux route nationale 7',
        content: 'Des travaux sont prévus sur la RN7 du 15 au 20 mai.',
        publishedBy: UserModel(
          id: 'admin1',
          nom: 'ADMIN',
          prenoms: 'System',
          numCIN: 'ADMIN001',
          dateCIN: DateTime.now(),
          lieuCIN: 'Fianarantsoa',
          adresse: 'Mairie',
          role: UserRole.admin,
          codeUtilisateur: 'ADM001',
          email: 'admin@fianara.com',
          createdAt: DateTime.now(),
        ),
        publishedAt: DateTime.now().subtract(const Duration(days: 2)),
        isUrgent: true,
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }
}
