// lib/navigation/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/map_screen.dart';
import '../screens/announcements_screen.dart';
import '../screens/reports_screen.dart';
import '../screens/report_form_screen.dart';
import '../screens/profile_screen.dart';

// Importer avec des prefixes pour éviter les conflits
import '../screens/admin_home_screen.dart' as admin_home;
import '../screens/admin_reports_screen.dart';
import '../screens/admin_users_screen.dart';
import '../screens/admin_announcements_screen.dart';
import '../screens/admin_profile_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Routes publiques
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),

    // Routes utilisateur
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/map',
      name: 'map',
      builder: (context, state) => const MapScreen(),
    ),
    GoRoute(
      path: '/announcements',
      name: 'announcements',
      builder: (context, state) => const AnnouncementsScreen(),
    ),
    GoRoute(
      path: '/reports',
      name: 'reports',
      builder: (context, state) => const ReportsScreen(),
    ),
    GoRoute(
      path: '/report-form',
      name: 'report-form',
      builder: (context, state) => const ReportFormScreen(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),

    // Routes administrateur
    GoRoute(
      path: '/admin',
      name: 'admin',
      builder: (context, state) => const admin_home.AdminHomeScreen(),
    ),
    GoRoute(
      path: '/admin/reports',
      name: 'admin-reports',
      builder: (context, state) => const AdminReportsScreen(),
    ),
    GoRoute(
      path: '/admin/users',
      name: 'admin-users',
      builder: (context, state) => const AdminUsersScreen(),
    ),
    GoRoute(
      path: '/admin/announcements',
      name: 'admin-announcements',
      builder: (context, state) => const AdminAnnouncementsScreen(),
    ),
    GoRoute(
      path: '/admin/profile',
      name: 'admin-profile',
      builder: (context, state) => const AdminProfileScreen(),
    ),
  ],
);
