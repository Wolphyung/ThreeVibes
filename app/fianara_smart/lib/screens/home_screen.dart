import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../providers/auth_provider.dart';
import '../services/signalement_service.dart';
import '../models/signalement_model.dart';
import '../widgets/bottom_nav_bar.dart';
import 'map_screen.dart';
import 'announcements_screen.dart';
import 'reports_screen.dart';
import 'profile_screen.dart';
import 'chatbot_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const ReportsScreen(),
    const AnnouncementsScreen(),
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

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<SignalementModel> _signalements = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSignalements();
  }

  Future<void> _loadSignalements() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await SignalementService.getAllSignalements();
      setState(() {
        _signalements =
            data.map((json) => SignalementModel.fromJson(json)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  int get _totalReports => _signalements.length;
  int get _inProgressReports =>
      _signalements.where((r) => r.status == 'EN COURS').length;
  int get _resolvedReports =>
      _signalements.where((r) => r.status == 'TRAITÉ').length;
  List<SignalementModel> get _recentReports => _signalements.take(3).toList();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadSignalements,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(24, 50, 24, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Bonjour',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.white70),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user?.fullName ?? 'Citoyen',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(Icons.location_city,
                              color: Colors.white, size: 24),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_on,
                              size: 14, color: Colors.white),
                          SizedBox(width: 4),
                          Text('Fianarantsoa',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Cartes statistiques
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        title: 'Signalements',
                        value: _totalReports.toString(),
                        icon: Icons.report_problem_outlined,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildStatCard(
                        title: 'En cours',
                        value: _inProgressReports.toString(),
                        icon: Icons.hourglass_empty,
                        color: AppColors.warning,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildStatCard(
                        title: 'Résolus',
                        value: _resolvedReports.toString(),
                        icon: Icons.check_circle_outline,
                        color: AppColors.resolved,
                      ),
                    ),
                  ],
                ),
              ),

              // Actions rapides
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Actions rapides',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.add_location_alt,
                            label: 'Signaler',
                            color: AppColors.error,
                            onTap: () =>
                                Navigator.pushNamed(context, '/report-form'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.description_outlined,
                            label: 'Dossiers',
                            color: AppColors.primary,
                            onTap: () =>
                                Navigator.pushNamed(context, '/dossiers'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.map_outlined,
                            label: 'Carte',
                            color: AppColors.primary,
                            onTap: () => Navigator.pushNamed(context, '/map'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.notifications_none,
                            label: 'Annonces',
                            color: AppColors.warning,
                            onTap: () =>
                                Navigator.pushNamed(context, '/announcements'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Signalements récents
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Signalements récents',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/reports'),
                      style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary),
                      child: const Text('Voir tout'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Liste des signalements récents
              _isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : _errorMessage != null
                      ? Padding(
                          padding: const EdgeInsets.all(40),
                          child: Column(
                            children: [
                              const Icon(Icons.error_outline,
                                  size: 60, color: Colors.red),
                              const SizedBox(height: 12),
                              Text(_errorMessage!,
                                  style: const TextStyle(color: Colors.red)),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _loadSignalements,
                                child: const Text('RÉESSAYER'),
                              ),
                            ],
                          ),
                        )
                      : _recentReports.isEmpty
                          ? Container(
                              padding: const EdgeInsets.all(40),
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Icon(Icons.report_problem_outlined,
                                      size: 60, color: AppColors.textHint),
                                  const SizedBox(height: 12),
                                  Text('Aucun signalement',
                                      style: TextStyle(
                                          color: AppColors.textSecondary)),
                                  const SizedBox(height: 8),
                                  ElevatedButton.icon(
                                    onPressed: () => Navigator.pushNamed(
                                        context, '/report-form'),
                                    icon: const Icon(Icons.add, size: 18),
                                    label: const Text('Premier signalement'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              itemCount: _recentReports.length,
                              itemBuilder: (context, index) {
                                return _buildReportCard(
                                    context, _recentReports[index]);
                              },
                            ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const ChatbotScreen())),
        backgroundColor: AppColors.primary,
        elevation: 4,
        child: const Icon(Icons.chat_bubble_outline, size: 26),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 2)),
        ],
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(title,
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
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
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(label,
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w500, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(BuildContext context, SignalementModel report) {
    String statusText = _getStatusText(report.status);
    Color statusColor = _getStatusColor(report.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.border, width: 1),
      ),
      child: InkWell(
        onTap: () =>
            Navigator.pushNamed(context, '/report-detail', arguments: report),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_getReportIcon(report.type),
                    color: statusColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(report.type,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                        maxLines: 1),
                    const SizedBox(height: 4),
                    Text(report.description,
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textSecondary),
                        maxLines: 1),
                    const SizedBox(height: 2),
                    Text(report.timeAgo,
                        style: const TextStyle(
                            fontSize: 10, color: AppColors.textHint)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(statusText,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: statusColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'EN COURS':
        return 'EN COURS';
      case 'TRAITÉ':
        return 'TRAITÉ';
      case 'REJETÉ':
        return 'REJETÉ';
      default:
        return 'EN ATTENTE';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'EN COURS':
        return AppColors.inProgress;
      case 'TRAITÉ':
        return AppColors.resolved;
      case 'REJETÉ':
        return AppColors.error;
      default:
        return AppColors.pending;
    }
  }

  IconData _getReportIcon(String type) {
    switch (type.toLowerCase()) {
      case 'propreté':
        return Icons.cleaning_services;
      case 'infrastructure':
        return Icons.build;
      case 'sécurité':
        return Icons.security;
      case 'trafic':
        return Icons.traffic;
      case 'éclairage':
        return Icons.lightbulb;
      case 'déchets':
        return Icons.delete;
      case 'eau':
        return Icons.water_damage;
      default:
        return Icons.report_problem;
    }
  }
}
