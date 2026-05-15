import 'package:flutter/foundation.dart'; // Added for kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/notification_model.dart';

import 'package:fianara_smart_city/models/report_model.dart';

class NotificationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const String _boxName = 'notifications_box';

  static Future<void> init() async {
    // 1. Init Hive
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(AppNotificationAdapter());
    }
    final box = await Hive.openBox<AppNotification>(_boxName);
    print('📦 Hive Notification Box opened. Total: ${box.length}');

    // 2. Check for missed notifications
    final unreadCount = box.values.where((n) => !n.isRead).length;
    if (unreadCount > 0) {
      Future.delayed(const Duration(seconds: 2), () {
        showSnackBar('Vous avez $unreadCount nouvelles notifications en attente.');
      });
    }

    // 3. Init Local Notifications
    if (!kIsWeb) {
      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosInit = DarwinInitializationSettings();
      await _localNotifications.initialize(
        const InitializationSettings(android: androidInit, iOS: iosInit),
      );
    }
  }

  static Future<void> saveAndShow(AppNotification notification) async {
    // 1. Save to Hive
    final box = Hive.box<AppNotification>(_boxName);
    await box.add(notification);

    // 2. Show Top Alert (MaterialBanner)
    print('📢 Showing top alert for: ${notification.title}');
    showTopAlert(notification);

    // 3. Mobile System Notification
    if (!kIsWeb) {
      const androidDetails = AndroidNotificationDetails(
        'threevibes_alerts',
        'Alertes ThreeVibes',
        importance: Importance.max,
        priority: Priority.high,
      );
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.message,
        const NotificationDetails(android: androidDetails, iOS: DarwinNotificationDetails()),
      );
    }
  }

  static void showTopAlert(AppNotification notification) {
    final state = messengerKey.currentState;
    if (state == null) return;

    state.removeCurrentMaterialBanner();
    state.showMaterialBanner(
      MaterialBanner(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              notification.title,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              notification.message,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
        leading: Icon(_getIconForType(notification.type), color: Colors.white),
        backgroundColor: _getColorForType(notification.type),
        actions: [
          TextButton(
            onPressed: () {
              state.hideCurrentMaterialBanner();
              // Redirect to Signalement Detail
              if (notification.type == 'SIGNALEMENT' && notification.data != null) {
                try {
                  final signalementData = notification.data!['signalement'];
                  if (signalementData != null) {
                    final report = ReportModel.fromJson(signalementData);
                    navigatorKey.currentState?.pushNamed(
                      '/report-detail',
                      arguments: report,
                    );
                  }
                } catch (e) {
                  print('Error navigating to report: $e');
                }
              }
            },
            child: const Text('VOIR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () => state.hideCurrentMaterialBanner(),
            child: const Text('FERMER', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );

    // Auto-hide after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      state.hideCurrentMaterialBanner();
    });
  }

  static void showSnackBar(String message, {bool isError = false}) {
    messengerKey.currentState?.removeCurrentSnackBar();
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.blueGrey,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static IconData _getIconForType(String? type) {
    switch (type) {
      case 'SIGNALEMENT': return Icons.report_problem;
      case 'ALERTE': return Icons.warning;
      case 'ANNONCE': return Icons.announcement;
      default: return Icons.notifications;
    }
  }

  static Color _getColorForType(String? type) {
    switch (type) {
      case 'SIGNALEMENT': return Colors.orange.shade800;
      case 'ALERTE': return Colors.red.shade800;
      case 'ANNONCE': return Colors.blue.shade800;
      default: return Colors.indigo;
    }
  }

  static List<AppNotification> getNotifications() {
    final box = Hive.box<AppNotification>(_boxName);
    return box.values.toList().reversed.toList();
  }
}
