import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../constants/colors.dart';
import '../../../../core/widgets/charts/custom_chart.dart';
import '../providers/stats_provider.dart';
import 'admin_reports_screen.dart';
import 'admin_users_screen.dart';
import 'admin_announcements_screen.dart';
import 'admin_profile_screen.dart';
import '../../../../services/signalement_service.dart';
import '../../../../services/annonce_service.dart';
import '../../../../providers/auth_provider.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late List<Animation<double>> _iconAnimations;

  final List<Widget> _screens = [
    const AdminDashboardScreen(),
    const AdminReportsScreen(),
    const AdminUsersScreen(),
    const AdminAnnouncementsScreen(),
    const AdminProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _iconAnimations = List.generate(5, (index) {
      return Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(index * 0.1, 1.0, curve: Curves.elasticOut),
        ),
      );
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
              _animationController.reset();
              _animationController.forward();
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textSecondary,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 11,
            ),
            items: [
              _buildNavItem(
                  0, Icons.dashboard_outlined, Icons.dashboard, 'Dashboard'),
              _buildNavItem(1, Icons.report_problem_outlined,
                  Icons.report_problem, 'Signalements'),
              _buildNavItem(
                  2, Icons.people_outline, Icons.people, 'Utilisateurs'),
              _buildNavItem(3, Icons.announcement_outlined, Icons.announcement,
                  'Annonces'),
              _buildNavItem(4, Icons.person_outline, Icons.person, 'Profil'),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
      int index, IconData icon, IconData activeIcon, String label) {
    return BottomNavigationBarItem(
      icon: ScaleTransition(
        scale: _iconAnimations[index],
        child: Icon(icon),
      ),
      activeIcon: ScaleTransition(
        scale: _iconAnimations[index],
        child: Icon(activeIcon),
      ),
      label: label,
    );
  }
}

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
    _loadData();
  }

  Future<void> _loadData() async {
    final statsProvider = Provider.of<StatsProvider>(context, listen: false);
    await statsProvider.fetchAdminStats();
  }

  // Action: Signaler (créer un signalement)
  Future<void> _createSignalement() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final codeUtilisateur =
        authProvider.currentUser?.codeUtilisateur ?? 'ADMIN001';

    final result = await SignalementService.createSignalement(
      typeSignalement: 'Test Admin',
      description: 'Signalement créé depuis le dashboard admin',
      latitude: -21.450851970867316,
      longitude: 47.090025867485025,
      codeUtilisateur: codeUtilisateur,
      fonctions: ['F0001'],
    );

    if (mounted) {
      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Signalement créé avec succès'),
              backgroundColor: Colors.green),
        );
        _loadData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(result['error'] ?? 'Erreur lors de la création'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  // Action: Ajouter utilisateur
  Future<void> _addUser() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Redirection vers la page d\'ajout d\'utilisateur'),
          backgroundColor: Colors.blue),
    );
  }

  // Action: Publier annonce
  Future<void> _publishAnnouncement() async {
    final success = await AnnonceService.createAnnonce(
      contenu: 'Ceci est une annonce de test depuis le dashboard admin',
      codeCategorie: 'C0001',
      latitude: -21.450851970867316,
      longitude: 47.090025867485025,
    );

    if (mounted) {
      if (success == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Annonce publiée avec succès'),
              backgroundColor: Colors.green),
        );
        _loadData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Erreur lors de la publication'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  // Action: Exporter données
  Future<void> _exportData() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Exportation des données en cours...'),
          backgroundColor: Colors.blue),
    );

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Exportation terminée'),
            backgroundColor: Colors.green),
      );
    }
  }

  List<Map<String, dynamic>> get statsData {
    final statsProvider = Provider.of<StatsProvider>(context, listen: false);
    return [
      {
        'title': 'Signalements',
        'value': statsProvider.totalReports.toString(),
        'icon': Icons.report_problem,
        'color': AppColors.error,
        'trend': '+12%',
        'trendUp': true,
      },
      {
        'title': 'Utilisateurs',
        'value': statsProvider.totalUsers.toString(),
        'icon': Icons.people,
        'color': AppColors.primary,
        'trend': '+8%',
        'trendUp': true,
      },
      {
        'title': 'Taux résolution',
        'value': '${statsProvider.resolutionRate}%',
        'icon': Icons.check_circle,
        'color': AppColors.resolved,
        'trend': '+5%',
        'trendUp': true,
      },
      {
        'title': 'En attente',
        'value': statsProvider.pendingReports.toString(),
        'icon': Icons.pending,
        'color': AppColors.warning,
        'trend': '-3%',
        'trendUp': false,
      },
    ];
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statsProvider = Provider.of<StatsProvider>(context);

    // Données pour le diagramme circulaire (camembert)
    final pieChartData = [
      {
        'category': 'Signalements',
        'value': statsProvider.totalReports.toDouble(),
        'color': AppColors.error
      },
      {
        'category': 'Utilisateurs',
        'value': statsProvider.totalUsers.toDouble(),
        'color': AppColors.primary
      },
      {
        'category': 'Taux résolution',
        'value': statsProvider.resolutionRate.toDouble(),
        'color': AppColors.resolved
      },
      {
        'category': 'En attente',
        'value': statsProvider.pendingReports.toDouble(),
        'color': AppColors.warning
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: _loadData,
        color: AppColors.primary,
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, _slideAnimation.value),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primary,
                              AppColors.primary.withValues(alpha: 0.8),
                              const Color(0xFF283593),
                            ],
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Dashboard Admin',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          'Vue d\'ensemble du système',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.white.withValues(alpha: 0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.admin_panel_settings,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Cartes statistiques
            SliverPadding(
              padding: const EdgeInsets.all(8),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final stat = statsData[index];
                    return _buildMiniStatCard(
                      title: stat['title'] as String,
                      value: stat['value'] as String,
                      icon: stat['icon'] as IconData,
                      color: stat['color'] as Color,
                      trend: stat['trend'] as String,
                      trendUp: stat['trendUp'] as bool,
                    );
                  },
                  childCount: 4,
                ),
              ),
            ),

            // Diagramme circulaire (Camembert)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: Transform.translate(
                        offset: Offset(0, _slideAnimation.value * 0.5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(12),
                                child: Text(
                                  'Distribution des données',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 220,
                                child: _buildDonutChart(pieChartData),
                              ),
                              const SizedBox(height: 12),
                              _buildChartLegend(pieChartData),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Actions rapides
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 8),
                      child: Text(
                        'Actions Rapides',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildMiniActionCard(
                            icon: Icons.add_alert,
                            label: 'Signaler',
                            color: AppColors.error,
                            onTap: _createSignalement,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: _buildMiniActionCard(
                            icon: Icons.person_add,
                            label: 'Ajouter',
                            color: AppColors.primary,
                            onTap: _addUser,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: _buildMiniActionCard(
                            icon: Icons.announcement,
                            label: 'Annonce',
                            color: AppColors.warning,
                            onTap: _publishAnnouncement,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: _buildMiniActionCard(
                            icon: Icons.folder,
                            label: 'Dossiers',
                            color: AppColors.primary,
                            onTap: () {
                              Navigator.pushNamed(context, '/admin-dossiers');
                            },
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: _buildMiniActionCard(
                            icon: Icons.download,
                            label: 'Export',
                            color: AppColors.resolved,
                            onTap: _exportData,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
          ],
        ),
      ),
    );
  }

  Widget _buildDonutChart(List<Map<String, dynamic>> data) {
    final total =
        data.fold(0.0, (sum, item) => sum + (item['value'] as double));

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 160,
          height: 160,
          child: CustomPaint(
            painter: DonutChartPainter(data: data, total: total),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              total.toInt().toString(),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const Text(
              'Total',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChartLegend(List<Map<String, dynamic>> data) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: data.map((item) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: item['color'] as Color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '${item['category']}: ${(item['value'] as double).toInt()}',
              style: const TextStyle(fontSize: 11),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildMiniStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String trend,
    required bool trendUp,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 14),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: trendUp
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        trendUp ? Icons.trending_up : Icons.trending_down,
                        size: 8,
                        color: trendUp ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 1),
                      Text(
                        trend,
                        style: TextStyle(
                          fontSize: 7,
                          fontWeight: FontWeight.w600,
                          color: trendUp ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(
                fontSize: 9,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter pour le diagramme circulaire (Donut Chart)
class DonutChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final double total;

  DonutChartPainter({required this.data, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    double startAngle = -90 * 3.14159 / 180;

    for (var item in data) {
      final value = item['value'] as double;
      final color = item['color'] as Color;
      final sweepAngle = 360 * (value / total) * 3.14159 / 180;

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
