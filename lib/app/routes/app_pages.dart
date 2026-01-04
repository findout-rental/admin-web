import 'package:get/get.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/dashboard/dashboard_page.dart';
import '../../presentation/pages/pending_registrations/pending_registrations_page.dart';
import '../../presentation/pages/users/all_users_page.dart';
import '../../presentation/pages/apartments/all_apartments_page.dart';
import '../../presentation/pages/bookings/all_bookings_page.dart';
import '../../presentation/pages/settings/profile_page.dart';
import '../../presentation/pages/settings/language_page.dart';
import '../../presentation/pages/settings/theme_page.dart';

class AppPages {
  AppPages._();

  static const String initial = '/login';

  static final routes = [
    GetPage(
      name: '/login',
      page: () => const LoginPage(),
      // Middleware removed to fix navigation issue
      // Auth checks will be handled in pages
    ),
    // Middleware removed to fix navigation issue
    // Auth checks will be handled in pages or via a different mechanism
    GetPage(
      name: '/dashboard',
      page: () => const DashboardPage(),
    ),
    GetPage(
      name: '/pending-registrations',
      page: () => const PendingRegistrationsPage(),
    ),
    GetPage(
      name: '/users',
      page: () => const AllUsersPage(),
    ),
    GetPage(
      name: '/apartments',
      page: () => const AllApartmentsPage(),
    ),
    GetPage(
      name: '/bookings',
      page: () => const AllBookingsPage(),
    ),
    GetPage(
      name: '/settings/profile',
      page: () => const ProfilePage(),
    ),
    GetPage(
      name: '/settings/language',
      page: () => const LanguagePage(),
    ),
    GetPage(
      name: '/settings/theme',
      page: () => const ThemePage(),
    ),
  ];
}
