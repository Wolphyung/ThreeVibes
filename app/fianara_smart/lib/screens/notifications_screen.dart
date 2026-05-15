import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import '../models/notification_model.dart';
import '../models/report_model.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<AppNotification> _notifications;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    setState(() {
      _notifications = NotificationService.getNotifications();
      // Mark all as read
      for (var n in _notifications) {
        if (!n.isRead) {
          n.isRead = true;
          n.save(); // HiveObject.save()
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadNotifications,
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? const Center(
              child: Text('Aucune notification pour le moment.'),
            )
          : ListView.separated(
              itemCount: _notifications.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getCategoryColor(notification.type),
                    child: Icon(
                      _getCategoryIcon(notification.type),
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    notification.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notification.message),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('dd/MM/yyyy HH:mm')
                            .format(notification.timestamp),
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                  onTap: () {
                    if (notification.type == 'SIGNALEMENT' &&
                        notification.data != null) {
                      try {
                        final signalementData =
                            notification.data!['signalement'];
                        if (signalementData != null) {
                          final report = ReportModel.fromJson(signalementData);
                          Navigator.pushNamed(
                            context,
                            '/report-detail',
                            arguments: report,
                          );
                        }
                      } catch (e) {
                        print('Error navigating to report: $e');
                      }
                    }
                  },
                );
              },
            ),
    );
  }

  Color _getCategoryColor(String? type) {
    switch (type) {
      case 'SIGNALEMENT':
        return Colors.orange;
      case 'ALERTE':
        return Colors.red;
      case 'ANNONCE':
        return Colors.blue;
      default:
        return Colors.blueGrey;
    }
  }

  IconData _getCategoryIcon(String? type) {
    switch (type) {
      case 'SIGNALEMENT':
        return Icons.report_problem;
      case 'ALERTE':
        return Icons.warning;
      case 'ANNONCE':
        return Icons.announcement;
      default:
        return Icons.notifications;
    }
  }
}
