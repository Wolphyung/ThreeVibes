import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../models/report_model.dart';
import '../providers/report_provider.dart';

class ReportDetailScreen extends StatefulWidget {
  final ReportModel report;

  const ReportDetailScreen({
    super.key,
    required this.report,
  });

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final report = widget.report;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail du signalement'),
        actions: [
          if (Provider.of<ReportProvider>(context).isAdmin)
            PopupMenuButton<String>(
              onSelected: (value) {
                _updateStatus(value);
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'En attente',
                  child: Text('En attente'),
                ),
                const PopupMenuItem(
                  value: 'En cours',
                  child: Text('En cours'),
                ),
                const PopupMenuItem(
                  value: 'Résolu',
                  child: Text('Résolu'),
                ),
                const PopupMenuItem(
                  value: 'Rejeté',
                  child: Text('Rejeté'),
                ),
              ],
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: report.status.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: report.status.color,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Statut actuel',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          report.status.label,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: report.status.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getColorForReportType(report.type),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      report.type.icon,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              report.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  report.formattedDate,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.location_on,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    report.locationAddress,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              report.description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            if (report.imageUrl != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Photo',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(report.imageUrl!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildVoteButton(
                  icon: Icons.thumb_up_outlined,
                  count: report.upvotes,
                  color: Colors.green,
                  onTap: () {},
                ),
                const SizedBox(width: 24),
                _buildVoteButton(
                  icon: Icons.thumb_down_outlined,
                  count: report.downvotes,
                  color: Colors.red,
                  onTap: () {},
                ),
                const Spacer(),
                _buildActionButton(
                  icon: Icons.share_outlined,
                  label: 'Partager',
                  onTap: () {},
                ),
                const SizedBox(width: 16),
                _buildActionButton(
                  icon: Icons.flag_outlined,
                  label: 'Signaler',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (report.resolvedAt != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Résolu le',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            '${report.resolvedAt!.day}/${report.resolvedAt!.month}/${report.resolvedAt!.year}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Contacter la mairie
                  },
                  icon: const Icon(Icons.message_outlined),
                  label: const Text('Contacter'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Suivre le signalement
                  },
                  icon: const Icon(Icons.notifications_active),
                  label: const Text('Suivre'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColorForReportType(ReportType type) {
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

  Widget _buildVoteButton({
    required IconData icon,
    required int count,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 4),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 14,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  void _updateStatus(String newStatus) {
    final status = ReportStatus.fromString(newStatus);
    Provider.of<ReportProvider>(context, listen: false)
        .updateReportStatus(widget.report.id, status);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Statut mis à jour : $newStatus'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
