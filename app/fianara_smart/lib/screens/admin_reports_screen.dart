// lib/features/admin/presentation/screens/admin_reports_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../services/signalement_service.dart';
import '../../models/signalement_model.dart';

class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  State<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> {
  String _selectedFilter = 'Tous';
  String _searchQuery = '';
  bool _isLoading = true;
  bool _isProcessing = false;
  List<SignalementModel> _signalements = [];
  List<SignalementModel> _searchResults = [];
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
    // Si une recherche est active, utiliser les résultats de recherche
    if (_searchQuery.isNotEmpty) {
      return _searchResults;
    }

    var filtered = _signalements;

    if (_selectedFilter != 'Tous') {
      filtered = filtered.where((s) => s.status == _selectedFilter).toList();
    }

    return filtered;
  }

  void _performSearch(String query) {
    setState(() {
      _searchQuery = query;

      if (query.isEmpty) {
        _searchResults = [];
      } else {
        _searchResults = _signalements
            .where((s) =>
                s.type.toLowerCase().contains(query.toLowerCase()) ||
                s.description.toLowerCase().contains(query.toLowerCase()) ||
                s.codeUtilisateur.toLowerCase().contains(query.toLowerCase()) ||
                s.code.toLowerCase().contains(query.toLowerCase()) ||
                s.status.toLowerCase().contains(query.toLowerCase()) ||
                s.priorite.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
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
                            horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.search,
                                        size: 16, color: AppColors.primary),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Résultats pour : "$_searchQuery" (${filteredSignalements.length} signalement${filteredSignalements.length > 1 ? 's' : ''})',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _performSearch('');
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          shape: BoxShape.circle,
                                        ),
                                        child:
                                            const Icon(Icons.close, size: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _searchQuery.isNotEmpty
                                        ? Icons.search_off
                                        : Icons.report_off,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _searchQuery.isNotEmpty
                                        ? 'Aucun résultat pour "$_searchQuery"'
                                        : 'Aucun signalement trouvé',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  if (_searchQuery.isNotEmpty)
                                    TextButton(
                                      onPressed: () {
                                        _performSearch('');
                                      },
                                      child: const Text('Effacer la recherche'),
                                    ),
                                ],
                              ),
                            )
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
              style: const TextStyle(
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
                  // Icône de signalement
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: priorityColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getTypeIcon(report.type),
                      color: priorityColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                report.type,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
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
                        const SizedBox(height: 4),
                        Text(
                          report.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.person_outline,
                                  size: 12,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  report.codeUtilisateur,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  size: 12,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _formatTime(report.dateSignalement),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'propreté':
        return Icons.cleaning_services;
      case 'travaux':
        return Icons.construction;
      case 'eau':
        return Icons.water_damage;
      case 'accident':
        return Icons.car_crash;
      case 'incident':
        return Icons.warning;
      default:
        return Icons.report_problem;
    }
  }

  void _showReportDetails(SignalementModel report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
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
                    _buildDetailRow('Code utilisateur', report.codeUtilisateur),
                    _buildDetailRow('Type', report.type),
                    _buildDetailRow('Description', report.description),
                    _buildDetailRow(
                        'Date', _formatFullDate(report.dateSignalement)),
                    _buildDetailRow('Statut', report.status,
                        statusColor: _getStatusColor(report.status)),
                    _buildDetailRow('Priorité', report.priorite,
                        statusColor: _getPriorityColor(report.priorite)),
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
                      runSpacing: 8,
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
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _showDeleteConfirmation(report);
                            },
                            icon: const Icon(Icons.delete, size: 18),
                            label: const Text('SUPPRIMER'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.error,
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
        images: oldReport.images,
      );

      setState(() {
        _signalements[index] = updatedReport;
        // Mettre à jour aussi les résultats de recherche si nécessaire
        if (_searchQuery.isNotEmpty) {
          _performSearch(_searchQuery);
        }
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

  Future<void> _deleteSignalement(String code) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final success = await SignalementService.deleteSignalement(code);

      if (success) {
        setState(() {
          _signalements.removeWhere((s) => s.code == code);
          if (_searchQuery.isNotEmpty) {
            _performSearch(_searchQuery);
          }
          _isProcessing = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Signalement supprimé avec succès'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        throw Exception('Erreur lors de la suppression');
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showDeleteConfirmation(SignalementModel report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text(
          'Voulez-vous vraiment supprimer le signalement "${report.code}" ?\nCette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteSignalement(report.code);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('SUPPRIMER'),
          ),
        ],
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
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
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
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
    final controller = TextEditingController(text: _searchQuery);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rechercher un signalement'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Type, description, code utilisateur...',
                hintStyle: const TextStyle(fontSize: 13),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: AppColors.background,
              ),
              onSubmitted: (value) {
                _performSearch(value);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Suggestions de recherche :',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildSearchSuggestion(controller, 'Propreté'),
                      _buildSearchSuggestion(controller, 'Incident'),
                      _buildSearchSuggestion(controller, 'U0007'),
                      _buildSearchSuggestion(controller, 'EN COURS'),
                      _buildSearchSuggestion(controller, 'URGENT'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              _performSearch(controller.text);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('Rechercher'),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSuggestion(
      TextEditingController controller, String suggestion) {
    return GestureDetector(
      onTap: () {
        controller.text = suggestion;
        _performSearch(suggestion);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Text(
          suggestion,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.primary,
          ),
        ),
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
