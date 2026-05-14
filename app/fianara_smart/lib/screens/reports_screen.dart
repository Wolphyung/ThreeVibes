import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../models/report_model.dart';
import '../providers/report_provider.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen>
    with SingleTickerProviderStateMixin {
  String _selectedFilter = 'Tous';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> _filters = ['Tous', 'En cours', 'Traités', 'Rejetés'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportProvider>(context, listen: false).fetchReports();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  List<ReportModel> _filterReports(List<ReportModel> reports) {
    return reports.where((report) {
      // Filtre par statut
      if (_selectedFilter != 'Tous') {
        String reportStatus = '';
        switch (report.status) {
          case ReportStatus.inProgress:
            reportStatus = 'En cours';
            break;
          case ReportStatus.resolved:
            reportStatus = 'Traités';
            break;
          case ReportStatus.rejected:
            reportStatus = 'Rejetés';
            break;
          default:
            reportStatus = 'En attente';
        }
        if (reportStatus != _selectedFilter) return false;
      }
      return true;
    }).where((report) {
      // Filtre par recherche
      if (_searchQuery.isEmpty) return true;
      return report.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          report.description
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          report.locationAddress
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
    }).toList();
  }

  String _getStatusText(ReportStatus status) {
    switch (status) {
      case ReportStatus.inProgress:
        return 'EN COURS';
      case ReportStatus.resolved:
        return 'TRAITÉ';
      case ReportStatus.rejected:
        return 'REJETÉ';
      default:
        return 'EN ATTENTE';
    }
  }

  Color _getStatusColor(ReportStatus status) {
    switch (status) {
      case ReportStatus.inProgress:
        return AppColors.inProgress;
      case ReportStatus.resolved:
        return AppColors.resolved;
      case ReportStatus.rejected:
        return AppColors.error;
      default:
        return AppColors.pending;
    }
  }

  Color _getTypeColor(ReportType type) {
    switch (type) {
      case ReportType.cleanliness:
        return Colors.green;
      case ReportType.infrastructure:
        return Colors.orange;
      case ReportType.security:
        return Colors.red;
      case ReportType.traffic:
        return Colors.blue;
      case ReportType.lighting:
        return Colors.amber;
      case ReportType.waste:
        return Colors.brown;
      case ReportType.water:
        return Colors.cyan;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(ReportType type) {
    switch (type) {
      case ReportType.cleanliness:
        return Icons.cleaning_services;
      case ReportType.infrastructure:
        return Icons.build;
      case ReportType.security:
        return Icons.security;
      case ReportType.traffic:
        return Icons.traffic;
      case ReportType.lighting:
        return Icons.lightbulb;
      case ReportType.waste:
        return Icons.delete;
      case ReportType.water:
        return Icons.water_damage;
      default:
        return Icons.report_problem;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header avec dégradé
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.primaryDark,
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Mes Signalements',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.filter_alt_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Suivez l\'évolution de vos signalements',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Barre de recherche
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Rechercher un signalement...',
                          hintStyle: TextStyle(color: AppColors.textHint),
                          prefixIcon:
                              Icon(Icons.search, color: AppColors.primary),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear,
                                      color: AppColors.textHint),
                                  onPressed: () {
                                    setState(() {
                                      _searchQuery = '';
                                      _searchController.clear();
                                    });
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Filtres
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: _filters.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: FilterChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      backgroundColor: Colors.grey[100],
                      selectedColor: AppColors.primary.withValues(alpha: 0.1),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      checkmarkColor: AppColors.primary,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Statistiques rapides
          Consumer<ReportProvider>(
            builder: (context, provider, child) {
              final reports = provider.reports;
              final total = reports.length;
              final enCours = reports
                  .where((r) => r.status == ReportStatus.inProgress)
                  .length;
              final traites = reports
                  .where((r) => r.status == ReportStatus.resolved)
                  .length;

              return Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _buildStatCard('Total', total.toString(),
                        Icons.report_problem, AppColors.primary),
                    const SizedBox(width: 8),
                    _buildStatCard('En cours', enCours.toString(),
                        Icons.hourglass_empty, AppColors.inProgress),
                    const SizedBox(width: 8),
                    _buildStatCard('Traités', traites.toString(),
                        Icons.check_circle, AppColors.resolved),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 8),

          // Liste des signalements
          Expanded(
            child: Consumer<ReportProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.reports.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final filteredReports = _filterReports(provider.reports);

                if (filteredReports.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.report_problem_outlined,
                          size: 80,
                          color: AppColors.textHint,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? 'Aucun signalement pour le moment'
                              : 'Aucun résultat pour "$_searchQuery"',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (_searchQuery.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                                _searchController.clear();
                              });
                            },
                            child: const Text('Effacer la recherche'),
                          ),
                        ] else ...[
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pushNamed(context, '/report-form');
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Nouveau signalement'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredReports.length,
                  itemBuilder: (context, index) {
                    final report = filteredReports[index];
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.1),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _animationController,
                          curve: Interval(
                            index / filteredReports.length,
                            1.0,
                            curve: Curves.easeOut,
                          ),
                        )),
                        child: _buildReportCard(report),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/report-form');
        },
        backgroundColor: AppColors.primary,
        elevation: 4,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(ReportModel report) {
    final statusText = _getStatusText(report.status);
    final statusColor = _getStatusColor(report.status);
    final typeColor = _getTypeColor(report.type);
    final typeIcon = _getTypeIcon(report.type);

    String refNumber = 'REF-${report.id.padLeft(3, '0')}';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/report-detail',
            arguments: report,
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec référence et statut
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: typeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      typeIcon,
                      color: typeColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          refNumber,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textHint,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          report.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                report.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),

              // Localisation et date
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: AppColors.textHint,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      report.locationAddress,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textHint,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: AppColors.textHint,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    report.timeAgo,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Progression
              if (report.status == ReportStatus.inProgress) ...[
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: 0.65,
                    backgroundColor: AppColors.border,
                    color: statusColor,
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '65% complété',
                  style: TextStyle(
                    fontSize: 10,
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.end,
                ),
              ] else if (report.status == ReportStatus.resolved) ...[
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.resolved.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle,
                          color: AppColors.resolved, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Signalement résolu avec succès',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.resolved,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
