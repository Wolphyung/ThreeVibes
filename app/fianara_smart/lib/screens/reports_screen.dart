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

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportProvider>(context, listen: false).fetchReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes signalements'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<ReportProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.reports.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.reports.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.report_problem_outlined,
                      size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Aucun signalement',
                      style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 8),
                  Text(
                    'Utilisez le bouton + pour signaler un problème',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.reports.length,
            itemBuilder: (context, index) {
              final report = provider.reports[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/report-detail',
                      arguments: report,
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: _getColorForReportType(report.type),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                report.type.icon,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    report.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    report.locationAddress,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Chip(
                              label: Text(
                                report.status.label,
                                style: const TextStyle(fontSize: 10),
                              ),
                              backgroundColor:
                                  report.status.color.withValues(alpha: 0.2),
                              labelStyle: TextStyle(color: report.status.color),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          report.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.access_time,
                                size: 14, color: AppColors.textHint),
                            const SizedBox(width: 4),
                            Text(
                              report.timeAgo,
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.textHint),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/report-detail',
                                  arguments: report,
                                );
                              },
                              child: const Text('VOIR DÉTAIL'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/report-form');
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
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
}
