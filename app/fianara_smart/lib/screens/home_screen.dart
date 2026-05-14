import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../providers/auth_provider.dart';
import '../widgets/bottom_nav_bar.dart';
import 'map_screen.dart';
import 'announcements_screen.dart';
import 'reports_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const MapScreen(),
    const AnnouncementsScreen(),
    const ReportsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          floating: true,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Bonjour ${authProvider.currentUser?.prenoms ?? "Visiteur"}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Bienvenue sur Fianara Smart City',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildStatsSection(context),
              const SizedBox(height: 24),
              _buildQuickActions(context),
              const SizedBox(height: 24),
              _buildRecentAnnouncements(context),
              const SizedBox(height: 24),
              _buildRecentReports(context),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Signalements',
            value: '24',
            icon: Icons.report_problem,
            color: AppColors.error,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'En cours',
            value: '12',
            icon: Icons.hourglass_empty,
            color: AppColors.warning,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'Résolus',
            value: '45',
            icon: Icons.check_circle,
            color: AppColors.success,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Actions rapides',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                icon: Icons.add_location,
                label: 'Signaler',
                color: AppColors.error,
                onTap: () {
                  Navigator.pushNamed(context, '/report-form');
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                icon: Icons.notifications_active,
                label: 'Annonces',
                color: AppColors.info,
                onTap: () {
                  Navigator.pushNamed(context, '/announcements');
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                icon: Icons.map,
                label: 'Carte',
                color: AppColors.secondary,
                onTap: () {
                  Navigator.pushNamed(context, '/map');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentAnnouncements(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Annonces récentes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/announcements');
              },
              child: const Text('Voir tout'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 2,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      const Icon(Icons.notifications, color: AppColors.primary),
                ),
                title: const Text('Nouvelle fonctionnalité'),
                subtitle: const Text('Découvrez les nouvelles options...'),
                trailing: const Text('Il y a 2h'),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentReports(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Signalements récents',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/reports');
              },
              child: const Text('Voir tout'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 2,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.warning, color: AppColors.warning),
                ),
                title: const Text('Déchet sur la voie publique'),
                subtitle: const Text('Ambatovolo, Fianarantsoa'),
                trailing: Chip(
                  label: const Text('En attente'),
                  backgroundColor: AppColors.pending.withValues(alpha: 0.2),
                  labelStyle: const TextStyle(fontSize: 10),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
