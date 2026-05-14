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
    String refNumber = 'SIG-2023-00${report.id}';
    String statusText = '';
    Color statusColor = AppColors.pending;

    switch (report.status) {
      case ReportStatus.inProgress:
        statusText = 'EN COURS';
        statusColor = AppColors.inProgress;
        break;
      case ReportStatus.resolved:
        statusText = 'TRAITÉ';
        statusColor = AppColors.resolved;
        break;
      case ReportStatus.rejected:
        statusText = 'REJETÉ';
        statusColor = AppColors.rejected;
        break;
      default:
        statusText = 'EN ATTENTE';
        statusColor = AppColors.pending;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails Signalement'),
        actions: [
          if (Provider.of<ReportProvider>(context).isAdmin)
            PopupMenuButton<String>(
              onSelected: (value) => _updateStatus(value),
              itemBuilder: (context) => [
                const PopupMenuItem(
                    value: 'En attente', child: Text('En attente')),
                const PopupMenuItem(value: 'En cours', child: Text('En cours')),
                const PopupMenuItem(value: 'Résolu', child: Text('Résolu')),
                const PopupMenuItem(value: 'Rejeté', child: Text('Rejeté')),
              ],
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'RÉF: $refNumber',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 12,
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              report.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Signalé le ${report.formattedDate}',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              report.description,
              style: TextStyle(
                fontSize: 15,
                height: 1.4,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'LOCALISATION',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          report.locationAddress,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 26),
                    child: Text(
                      'Lat: ${report.latitude.toStringAsFixed(4)}, Long: ${report.longitude.toStringAsFixed(4)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textHint,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'SUIVI DE L\'ÉTAT',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            _buildTimelineItem(
              title: 'Signalement Reçu',
              date: report.formattedDate,
              isFirst: true,
              isCompleted: true,
            ),
            _buildTimelineItem(
              title: 'En cours de traitement',
              date: '13 Oct 2023 • 09:15',
              isCompleted: report.status == ReportStatus.inProgress ||
                  report.status == ReportStatus.resolved,
              comment:
                  'Le dossier a été transmis au service technique de la voirie.',
            ),
            _buildTimelineItem(
              title: 'Intervention planifiée',
              date: 'En attente...',
              isCompleted: false,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.comment_outlined),
                    label: const Text('Commenter'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.share_outlined),
                    label: const Text('Partager'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String date,
    bool isFirst = false,
    bool isCompleted = false,
    String? comment,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? AppColors.resolved : AppColors.border,
                border: Border.all(
                  color: isCompleted ? AppColors.resolved : AppColors.textHint,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            if (!isFirst)
              Container(
                width: 2,
                height: 60,
                color: isCompleted ? AppColors.resolved : AppColors.border,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isFirst ? 0 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isCompleted
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textHint,
                  ),
                ),
                if (comment != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      comment,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _updateStatus(String newStatus) {
    final status = ReportStatus.fromString(newStatus);
    Provider.of<ReportProvider>(context, listen: false)
        .updateReportStatus(widget.report.id, status);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Statut mis à jour : $newStatus'),
        backgroundColor: AppColors.secondary,
      ),
    );
  }
}
