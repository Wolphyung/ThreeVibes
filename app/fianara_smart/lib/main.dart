import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/report_provider.dart';
import 'providers/announcement_provider.dart';
import 'providers/theme_provider.dart';

// Providers admin
import 'providers/admin_provider.dart';
import 'providers/stats_provider.dart';
import 'providers/admin_users_provider.dart';

// Écrans principaux
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/map_screen.dart';
import 'screens/announcements_screen.dart';
import 'screens/announcement_detail_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/report_form_screen.dart';
import 'screens/report_detail_screen.dart';
import 'screens/profile_screen.dart';

// Écrans Admin - Utilisation de préfixes pour éviter les conflits
import 'screens/admin_home_screen.dart' as admin;
import 'screens/admin_reports_screen.dart';
import 'screens/admin_users_screen.dart';
import 'screens/admin_announcements_screen.dart';
import 'screens/admin_profile_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/location_picker_screen.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:fianara_smart_city/services/notification_service.dart';
import 'package:fianara_smart_city/services/socket_service.dart';

// Modèles
import 'models/announcement_model.dart';
import 'models/report_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Initialize Services
  await NotificationService.init();
  SocketService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Providers principaux
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
        ChangeNotifierProvider(create: (_) => AnnouncementProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),

        // Providers Admin
        ChangeNotifierProvider(create: (_) => AdminProvider()),
        ChangeNotifierProvider(create: (_) => StatsProvider()),
        ChangeNotifierProvider(create: (_) => AdminUsersProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Fianara Smart City',
            navigatorKey: NotificationService.navigatorKey,
            scaffoldMessengerKey: NotificationService.messengerKey,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: '/',
            routes: {
              // Routes publiques
              '/': (context) => const SplashScreen(),
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),

              // Routes utilisateur
              '/home': (context) => const HomeScreen(),
              '/map': (context) => const MapScreen(),
              '/announcements': (context) => const AnnouncementsScreen(),
              '/reports': (context) => const ReportsScreen(),
              '/report-form': (context) => const ReportFormScreen(),
              '/profile': (context) => const ProfileScreen(),
              '/notifications': (context) => const NotificationsScreen(),
              '/location-picker': (context) => const LocationPickerScreen(),

              // Routes Admin
              '/admin': (context) => const admin.AdminHomeScreen(),
              '/admin/reports': (context) => const AdminReportsScreen(),
              '/admin/users': (context) => const AdminUsersScreen(),
              '/admin/announcements': (context) =>
                  const AdminAnnouncementsScreen(),
              '/admin/profile': (context) => const AdminProfileScreen(),
            },
            onGenerateRoute: (settings) {
              if (settings.name == '/announcement-detail') {
                final announcement = settings.arguments as AnnouncementModel;
                return MaterialPageRoute(
                  builder: (context) => AnnouncementDetailScreen(
                    announcement: announcement,
                  ),
                );
              }
              if (settings.name == '/report-detail') {
                final report = settings.arguments as ReportModel;
                return MaterialPageRoute(
                  builder: (context) => ReportDetailScreen(
                    report: report,
                  ),
                );
              }
              return null;
            },
          );
        },
      ),
    );
  }
}
