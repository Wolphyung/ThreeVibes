// lib/navigation/app_router.dart
// Supprimez la ligne 2
// import 'package:flutter/material.dart';  // À SUPPRIMER

import 'package:go_router/go_router.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/map_screen.dart';
import '../screens/announcements_screen.dart';
import '../screens/announcement_detail_screen.dart';
import '../screens/reports_screen.dart';
import '../screens/report_form_screen.dart';
import '../screens/report_detail_screen.dart';
import '../screens/profile_screen.dart';

// Imports admin
import '../screens/admin_home_screen.dart' as admin;
import '../screens/admin_reports_screen.dart';
import '../screens/admin_users_screen.dart';
import '../screens/admin_announcements_screen.dart';
import '../screens/admin_profile_screen.dart';

import '../models/announcement_model.dart';
import '../models/report_model.dart';

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

    // Routes admin
    GoRoute(
      path: '/admin',
      name: 'admin',
      builder: (context, state) => const admin.AdminHomeScreen(),
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

    // Routes avec paramètres
    GoRoute(
      path: '/announcement-detail',
      name: 'announcement-detail',
      builder: (context, state) {
        final announcement = state.extra as AnnouncementModel;
        return AnnouncementDetailScreen(announcement: announcement);
      },
    ),
    GoRoute(
      path: '/report-detail',
      name: 'report-detail',
      builder: (context, state) {
        final report = state.extra as ReportModel;
        return ReportDetailScreen(report: report);
      },
    ),
  ],
);
