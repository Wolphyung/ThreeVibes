import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'constants/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/report_provider.dart';
import 'providers/announcement_provider.dart';
import 'providers/theme_provider.dart';
import 'models/announcement_model.dart';
import 'models/report_model.dart';
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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
        ChangeNotifierProvider(create: (_) => AnnouncementProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Fianara Smart City',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: '/',
            routes: {
              '/': (context) => const SplashScreen(),
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/home': (context) => const HomeScreen(),
              '/map': (context) => const MapScreen(),
              '/announcements': (context) => const AnnouncementsScreen(),
              '/reports': (context) => const ReportsScreen(),
              '/report-form': (context) => const ReportFormScreen(),
              '/profile': (context) => const ProfileScreen(),
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
