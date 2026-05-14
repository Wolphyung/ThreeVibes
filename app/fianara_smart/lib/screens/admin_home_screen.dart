// lib/features/admin/presentation/screens/admin_home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../../../../core/widgets/charts/custom_chart.dart';
import '../providers/admin_provider.dart';
import '../providers/stats_provider.dart';
import '../widgets/admin_bottom_nav_bar.dart';
import 'admin_reports_screen.dart';
import 'admin_users_screen.dart';
import 'admin_announcements_screen.dart';
import 'admin_profile_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const AdminDashboardScreen(),
    //const AdminReportsScreen(),
    const AdminUsersScreen(),
    // const AdminAnnouncementsScreen(),
    const AdminProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: AdminBottomNavBar(
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

class AdminAnnouncementsScreen {
  const AdminAnnouncementsScreen();
}

class AdminReportsScreen {
  const AdminReportsScreen();
}

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animationController.forward();
    _loadData();
  }

  Future<void> _loadData() async {
    final statsProvider = Provider.of<StatsProvider>(context, listen: false);
    await statsProvider.fetchAdminStats();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statsProvider = Provider.of<StatsProvider>(context);

    return RefreshIndicator(
      key: _refreshKey,
      onRefresh: _loadData,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: CustomScrollView(
          slivers: [
            // Header Admin
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Dashboard Admin',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.admin_panel_settings,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Bienvenue, Administrateur',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Cartes statistiques principales
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final stats = [
                      {
                        'title': 'Signalements',
                        'value': statsProvider.totalReports.toString(),
                        'icon': Icons.report_problem,
                        'color': AppColors.error,
                        'trend': '+12%',
                      },
                      {
                        'title': 'Utilisateurs',
                        'value': statsProvider.totalUsers.toString(),
                        'icon': Icons.people,
                        'color': AppColors.primary,
                        'trend': '+8%',
                      },
                      {
                        'title': 'Taux résolution',
                        'value': '${statsProvider.resolutionRate}%',
                        'icon': Icons.check_circle,
                        'color': AppColors.resolved,
                        'trend': '+5%',
                      },
                      {
                        'title': 'Temps moyen',
                        'value': '${statsProvider.avgResponseTime}h',
                        'icon': Icons.timer,
                        'color': AppColors.warning,
                        'trend': '-2h',
                      },
                    ];
                    return _buildAdminStatCard(
                      title: stats[index]['title'] as String,
                      value: stats[index]['value'] as String,
                      icon: stats[index]['icon'] as IconData,
                      color: stats[index]['color'] as Color,
                      trend: stats[index]['trend'] as String,
                    );
                  },
                  childCount: 4,
                ),
              ),
            ),

            // Graphiques
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Aperçu des Signalements',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 250,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CustomChart(
                        data: statsProvider.reportsByMonth,
                        animationController: _animationController,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Actions rapides admin
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Actions Rapides',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildAdminQuickAction(
                          icon: Icons.verified_user,
                          label: 'MODÉRATION',
                          color: AppColors.primary,
                          onTap: () {
                            Navigator.pushNamed(context, '/admin/moderation');
                          },
                        ),
                        const SizedBox(width: 12),
                        _buildAdminQuickAction(
                          icon: Icons.analytics,
                          label: 'STATS',
                          color: AppColors.secondary,
                          onTap: () {
                            Navigator.pushNamed(context, '/admin/stats');
                          },
                        ),
                        const SizedBox(width: 12),
                        _buildAdminQuickAction(
                          icon: Icons.notifications_active,
                          label: 'ALERTES',
                          color: AppColors.warning,
                          onTap: () {
                            Navigator.pushNamed(context, '/admin/alerts');
                          },
                        ),
                        const SizedBox(width: 12),
                        _buildAdminQuickAction(
                          icon: Icons.settings,
                          label: 'CONFIG',
                          color: AppColors.textSecondary,
                          onTap: () {
                            Navigator.pushNamed(context, '/admin/config');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Signalements récents
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Signalements Récents',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/admin/reports');
                      },
                      child: const Text('Voir tout'),
                    ),
                  ],
                ),
              ),
            ),

            // Liste des signalements récents
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index >= statsProvider.recentReports.length) {
                    return const SizedBox(height: 80);
                  }
                  final report = statsProvider.recentReports[index];
                  return _buildRecentReportItem(report);
                },
                childCount: statsProvider.recentReports.length + 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String trend,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
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
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                trend.startsWith('+') ? Icons.trending_up : Icons.trending_down,
                size: 12,
                color: trend.startsWith('+') ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 4),
              Text(
                trend,
                style: TextStyle(
                  fontSize: 10,
                  color: trend.startsWith('+') ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdminQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentReportItem(dynamic report) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getStatusColor(report.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.report_problem,
              color: _getStatusColor(report.status),
            ),
          ),
          title: Text(
            report.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${report.userName} • ${report.location}',
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getPriorityColor(report.priority).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  report.priority,
                  style: TextStyle(
                    fontSize: 10,
                    color: _getPriorityColor(report.priority),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(report.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  report.status,
                  style: TextStyle(
                    fontSize: 10,
                    color: _getStatusColor(report.status),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatTime(report.createdAt),
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/admin/report-detail',
              arguments: report,
            );
          },
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'en cours':
        return AppColors.inProgress;
      case 'traité':
        return AppColors.resolved;
      case 'rejeté':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return AppColors.error;
      case 'élevé':
        return AppColors.warning;
      case 'normal':
        return AppColors.primary;
      default:
        return AppColors.textSecondary;
    }
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}j';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}min';
    } else {
      return "à l'instant";
    }
  }
}
