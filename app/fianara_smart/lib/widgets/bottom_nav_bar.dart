import 'package:flutter/material.dart';
import '../constants/colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map_outlined),
          activeIcon: Icon(Icons.map),
          label: 'Carte',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_outlined),
          activeIcon: Icon(Icons.notifications),
          label: 'Annonces',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.report_problem_outlined),
          activeIcon: Icon(Icons.report_problem),
          label: 'Signalements',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }
}
