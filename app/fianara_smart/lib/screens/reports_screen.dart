import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/signalement_model.dart';
import '../services/signalement_service.dart';

class ReportsScreen extends StatefulWidget {
  final String? userCode; // Si null, affiche tous les signalements (admin)
  const ReportsScreen({super.key, this.userCode});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen>
    with SingleTickerProviderStateMixin {
  String _selectedFilter = 'Tous';
  String _searchQuery = '';
  bool _isLoading = true;
  List<SignalementModel> _signalements = [];
  String? _errorMessage;

  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> _filters = ['Tous', 'EN COURS', 'TRAITÉ', 'REJETÉ'];

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

    _loadSignalements();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadSignalements() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final signalementsData = await SignalementService.getAllSignalements(
        searchQuery: _searchQuery.isEmpty ? null : _searchQuery,
      );

      setState(() {
        _signalements = signalementsData
            .map((json) => SignalementModel.fromJson(json))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  List<SignalementModel> get _filteredSignalements {
    var filtered = _signalements;

    if (_selectedFilter != 'Tous') {
      filtered = filtered.where((s) => s.status == _selectedFilter).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((s) =>
              s.type.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              s.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              s.codeUtilisateur
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  int get _totalCount => _signalements.length;
  int get _enCoursCount =>
      _signalements.where((s) => s.status == 'EN COURS').length;
  int get _traitesCount =>
      _signalements.where((s) => s.status == 'TRAITÉ').length;
  int get _rejetesCount =>
      _signalements.where((s) => s.status == 'REJETÉ').length;

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

  Color _getPriorityColor(String priority) {
    switch (priority.toUpperCase()) {
      case 'URGENT':
        return AppColors.error;
      case 'ÉLEVÉ':
        return AppColors.warning;
      case 'NORMAL':
        return AppColors.primary;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getTypeIcon(String type) {
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

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'propreté':
        return Colors.green;
      case 'infrastructure':
        return Colors.orange;
      case 'sécurité':
        return Colors.red;
      case 'trafic':
        return Colors.blue;
      case 'éclairage':
        return Colors.amber;
      case 'déchets':
        return Colors.brown;
      case 'eau':
        return Colors.cyan;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredSignalements = _filteredSignalements;

    return Scaffold(
<<<<<<< HEAD
      body: Column(
        children: [
          // Header avec dégradé
          Container(
            decoration: const BoxDecoration(
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
                          hintStyle: const TextStyle(color: AppColors.textHint),
                          prefixIcon: const Icon(Icons.search,
                              color: AppColors.primary),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
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
=======
      body: RefreshIndicator(
        onRefresh: _loadSignalements,
        child: Column(
          children: [
            // Header avec dégradé
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.primaryDark],
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
                          Text(
                            widget.userCode == null
                                ? 'Tous les Signalements'
                                : 'Mes Signalements',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.refresh,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            onPressed: _loadSignalements,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.userCode == null
                            ? 'Gérez tous les signalements citoyens'
                            : 'Suivez l\'évolution de vos signalements',
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
                            _loadSignalements();
                          },
                          decoration: InputDecoration(
                            hintText: 'Rechercher un signalement...',
                            hintStyle: const TextStyle(
                              color: AppColors.textHint,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: AppColors.primary,
                            ),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.clear,
                                      color: AppColors.textHint,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _searchQuery = '';
                                        _searchController.clear();
                                      });
                                      _loadSignalements();
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
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildStatCard(
                    'Total',
                    _totalCount.toString(),
                    Icons.report_problem,
                    AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  _buildStatCard(
                    'En cours',
                    _enCoursCount.toString(),
                    Icons.hourglass_empty,
                    AppColors.inProgress,
                  ),
                  const SizedBox(width: 8),
                  _buildStatCard(
                    'Traités',
                    _traitesCount.toString(),
                    Icons.check_circle,
                    AppColors.resolved,
                  ),
                  if (widget.userCode == null) ...[
                    const SizedBox(width: 8),
                    _buildStatCard(
                      'Rejetés',
                      _rejetesCount.toString(),
                      Icons.cancel,
                      AppColors.error,
                    ),
                  ],
                ],
              ),
            ),
>>>>>>> ad647aa55ee6cea1612beb10935f79bf917b2910

            const SizedBox(height: 8),

<<<<<<< HEAD
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
                        const Icon(
                          Icons.report_problem_outlined,
                          size: 80,
                          color: AppColors.textHint,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? 'Aucun signalement pour le moment'
                              : 'Aucun résultat pour "$_searchQuery"',
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
=======
            // Liste des signalements
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 64,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 16),
                              Text(_errorMessage!),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _loadSignalements,
                                child: const Text('RÉESSAYER'),
                              ),
                            ],
>>>>>>> ad647aa55ee6cea1612beb10935f79bf917b2910
                          ),
                        )
                      : filteredSignalements.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.report_problem_outlined,
                                    size: 80,
                                    color: AppColors.textHint,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _searchQuery.isEmpty
                                        ? 'Aucun signalement pour le moment'
                                        : 'Aucun résultat pour "$_searchQuery"',
                                    style: const TextStyle(
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
                                        _loadSignalements();
                                      },
                                      child: const Text('Effacer la recherche'),
                                    ),
                                  ] else ...[
                                    const SizedBox(height: 8),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/report-form');
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
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: filteredSignalements.length,
                              itemBuilder: (context, index) {
                                final report = filteredSignalements[index];
                                return FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0, 0.1),
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: _animationController,
                                        curve: Interval(
                                          index / filteredSignalements.length,
                                          1.0,
                                          curve: Curves.easeOut,
                                        ),
                                      ),
                                    ),
                                    child: _buildReportCard(report),
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
      floatingActionButton: widget.userCode != null
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/report-form');
              },
              backgroundColor: AppColors.primary,
              elevation: 4,
              child: const Icon(Icons.add),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
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
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(SignalementModel report) {
    final statusText = _getStatusText(report.status);
    final statusColor = _getStatusColor(report.status);
    final priorityColor = _getPriorityColor(report.priorite);
    final typeColor = _getTypeColor(report.type);
    final typeIcon = _getTypeIcon(report.type);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () {
          _showReportDetails(report);
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec type et statut
              Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: typeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(typeIcon, color: typeColor, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
<<<<<<< HEAD
                          refNumber,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textHint,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          report.title,
=======
                          report.type,
>>>>>>> ad647aa55ee6cea1612beb10935f79bf917b2910
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Code: ${report.code}',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textHint,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
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
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),

              // Priorité et date
              Row(
                children: [
<<<<<<< HEAD
                  const Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: AppColors.textHint,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      report.locationAddress,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textHint,
=======
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: priorityColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: priorityColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      report.priorite,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: priorityColor,
>>>>>>> ad647aa55ee6cea1612beb10935f79bf917b2910
                      ),
                    ),
                  ),
<<<<<<< HEAD
                  const SizedBox(width: 8),
=======
                  const SizedBox(width: 12),
>>>>>>> ad647aa55ee6cea1612beb10935f79bf917b2910
                  const Icon(
                    Icons.access_time,
                    size: 12,
                    color: AppColors.textHint,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    report.timeAgo,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textHint,
                    ),
                  ),
                  const Spacer(),
                  if (widget.userCode == null)
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      onPressed: () => _showReportDetails(report),
                      color: AppColors.primary,
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                      splashRadius: 20,
                    ),
                ],
              ),

              // Progression (si en cours)
              if (report.status == 'EN COURS') ...[
                const SizedBox(height: 12),
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
              ] else if (report.status == 'TRAITÉ') ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.resolved.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
<<<<<<< HEAD
                      Icon(Icons.check_circle,
                          color: AppColors.resolved, size: 16),
=======
                      Icon(
                        Icons.check_circle,
                        color: AppColors.resolved,
                        size: 16,
                      ),
>>>>>>> ad647aa55ee6cea1612beb10935f79bf917b2910
                      SizedBox(width: 8),
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

  void _showReportDetails(SignalementModel report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            report.type,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('Code', report.code),
                    _buildDetailRow('Type', report.type),
                    _buildDetailRow('Description', report.description),
                    _buildDetailRow('Date', report.formattedDate),
                    _buildDetailRow('Statut', report.status,
                        statusColor: _getStatusColor(report.status)),
                    _buildDetailRow('Priorité', report.priorite,
                        statusColor: _getPriorityColor(report.priorite)),
                    _buildDetailRow('Utilisateur', report.codeUtilisateur),
                    _buildDetailRow('Latitude', report.latitude.toString()),
                    _buildDetailRow('Longitude', report.longitude.toString()),
                    const SizedBox(height: 20),
                    const Text(
                      'Fonctions assignées',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: report.fonctions
                          .map((f) => Chip(
                                label: Text(f),
                                backgroundColor:
                                    AppColors.primary.withValues(alpha: 0.1),
                              ))
                          .toList(),
                    ),
                    if (widget.userCode == null) ...[
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                _updateReportStatus(report.code, 'TRAITÉ');
                              },
                              icon: const Icon(Icons.check_circle, size: 18),
                              label: const Text('MARQUER TRAITÉ'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.resolved,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? statusColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: statusColor != null
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 13,
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : Text(
                    value,
                    style: const TextStyle(fontSize: 13),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateReportStatus(String code, String newStatus) async {
    final index = _signalements.indexWhere((s) => s.code == code);
    if (index != -1) {
      final oldReport = _signalements[index];
      final updatedReport = SignalementModel(
        code: oldReport.code,
        type: oldReport.type,
        description: oldReport.description,
        dateSignalement: oldReport.dateSignalement,
        latitude: oldReport.latitude,
        longitude: oldReport.longitude,
        codeUtilisateur: oldReport.codeUtilisateur,
        fonctions: oldReport.fonctions,
        status: newStatus,
        priorite: oldReport.priorite,
      );

      setState(() {
        _signalements[index] = updatedReport;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Signalement marqué comme $newStatus'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }
}
