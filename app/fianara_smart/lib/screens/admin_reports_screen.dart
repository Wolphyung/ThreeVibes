// lib/features/admin/presentation/screens/admin_reports_screen.dart
import 'package:flutter/material.dart';
// Supprimer l'import inutilisé de provider
// import 'package:provider/provider.dart';  // À SUPPRIMER
import '../../../../core/constants/colors.dart';
import '../services/signalement_service.dart';
import '../models/signalement_model.dart';
// Supprimer l'import inutilisé de stats_provider
// import '../providers/stats_provider.dart';  // À SUPPRIMER

class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  State<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> {
  String _selectedFilter = 'Tous';
  String _searchQuery = '';
  bool _isLoading = true;
  List<SignalementModel> _signalements = [];
  String? _errorMessage;

  final List<String> _filters = ['Tous', 'EN COURS', 'TRAITÉ', 'REJETÉ'];

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
      final signalements = await SignalementService.getAllSignalements();
      setState(() {
        _signalements = signalements
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

  @override
  Widget build(BuildContext context) {
    final filteredSignalements = _filteredSignalements;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Gestion des Signalements',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSignalements,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(_errorMessage!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadSignalements,
                        child: const Text('RÉESSAYER'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    if (_searchQuery.isNotEmpty)
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Résultats pour: "$_searchQuery"',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                              child: const Text('Effacer'),
                            ),
                          ],
                        ),
                      ),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: List.generate(_filters.length, (index) {
                            final filter = _filters[index];
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
                                selectedColor:
                                    AppColors.primary.withValues(alpha: 0.1),
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                                checkmarkColor: AppColors.primary,
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          _buildQuickStat('Total', _totalCount.toString(),
                              AppColors.primary),
                          const SizedBox(width: 8),
                          _buildQuickStat('En cours', _enCoursCount.toString(),
                              AppColors.inProgress),
                          const SizedBox(width: 8),
                          _buildQuickStat('Traités', _traitesCount.toString(),
                              AppColors.resolved),
                          const SizedBox(width: 8),
                          _buildQuickStat('Rejetés', _rejetesCount.toString(),
                              AppColors.error),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: filteredSignalements.isEmpty
                          ? const Center(
                              child: Text('Aucun signalement trouvé'))
                          : ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: filteredSignalements.length,
                              itemBuilder: (context, index) {
                                final report = filteredSignalements[index];
                                return _buildReportCard(report);
                              },
                            ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildQuickStat(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(SignalementModel report) {
    final statusColor = _getStatusColor(report.status);
    final priorityColor = _getPriorityColor(report.priorite);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showReportDetails(report),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.report_problem,
                      color: statusColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report.type,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Code: ${report.code}',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                report.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatTime(report.dateSignalement),
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      report.status,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
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
                    _buildDetailRow(
                        'Date', _formatFullDate(report.dateSignalement)),
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
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateReportStatus(String code, String newStatus) async {
    // Créer une copie modifiable du signalement
    final index = _signalements.indexWhere((s) => s.code == code);
    if (index != -1) {
      final oldReport = _signalements[index];
      // Créer un nouveau signalement avec le statut modifié
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

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtrer les signalements'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Date récente'),
              leading: const Icon(Icons.date_range),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Priorité élevée'),
              leading: const Icon(Icons.priority_high),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rechercher'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Type, description, code...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onSubmitted: (value) {
            setState(() => _searchQuery = value);
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _searchQuery = controller.text);
              Navigator.pop(context);
            },
            child: const Text('Rechercher'),
          ),
        ],
      ),
    );
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
        return AppColors.textSecondary;
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

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays > 0) return '${difference.inDays}j';
    if (difference.inHours > 0) return '${difference.inHours}h';
    if (difference.inMinutes > 0) return '${difference.inMinutes}min';
    return "à l'instant";
  }

  String _formatFullDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
