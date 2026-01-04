import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../presentation/controllers/auth/auth_controller.dart';
import '../routes/app_pages.dart';

class AuthMiddleware extends GetMiddleware {
  // Use a static instance to avoid creating new instances
  static final AuthMiddleware instance = AuthMiddleware._();
  AuthMiddleware._();

  @override
  GetPage? onPageCalled(GetPage? page) {
    // Return the page as-is, don't modify it
    return page;
  }

  @override
  Widget onPageBuilt(Widget page) {
    // Return the page as-is without modification
    return page;
  }

  @override
  RouteSettings? redirect(String? route) {
    // Check if AuthController is registered
    if (!Get.isRegistered<AuthController>()) {
      // If not registered and trying to access protected route, redirect to login
      if (route != AppPages.initial) {
        return const RouteSettings(name: AppPages.initial);
      }
      return null; // Allow login page
    }

    try {
      final authController = Get.find<AuthController>();

      // If not authenticated and trying to access protected route
      if (!authController.isAuthenticated && route != AppPages.initial) {
        return const RouteSettings(name: AppPages.initial);
      }

      // If authenticated and trying to access login page
      if (authController.isAuthenticated && route == AppPages.initial) {
        return const RouteSettings(name: '/dashboard');
      }
    } catch (e) {
      // If controller access fails, redirect to login for protected routes
      if (route != AppPages.initial) {
        return const RouteSettings(name: AppPages.initial);
      }
    }

    return null; // Allow navigation
  }
}
