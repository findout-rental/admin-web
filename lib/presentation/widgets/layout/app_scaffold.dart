import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/responsive.dart';
import 'sidebar.dart';
import 'top_app_bar.dart';
import 'breadcrumb.dart';
import '../panels/notification_panel.dart';
import '../../controllers/notification/notification_controller.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final List<BreadcrumbItem>? breadcrumbs;
  final List<Widget>? actions;
  final bool showSidebar;
  final String? currentRoute;
  final bool showNotificationIcon;
  final bool showProfileIcon;

  const AppScaffold({
    super.key,
    required this.title,
    required this.child,
    this.breadcrumbs,
    this.actions,
    this.showSidebar = true,
    this.currentRoute,
    this.showNotificationIcon = true,
    this.showProfileIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    // Get current route if not provided
    final route = currentRoute ?? Get.currentRoute;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Check if screen is too small
        if (!Responsive.isDesktop(context)) {
          return _buildSmallScreenMessage(context);
        }

        return Stack(
          children: [
            Scaffold(
              appBar: TopAppBar(
                title: title,
                actions: actions,
                showNotificationIcon: showNotificationIcon,
                showProfileIcon: showProfileIcon,
              ),
              body: Row(
                children: [
                  // Sidebar
                  if (showSidebar)
                    Sidebar(
                      currentRoute: route,
                    ),
                  // Main Content Area
                  Expanded(
                    child: Column(
                      children: [
                        // Breadcrumbs
                        if (breadcrumbs != null && breadcrumbs!.isNotEmpty)
                          Breadcrumb(items: breadcrumbs!),
                        // Content
                        Expanded(
                          child: Container(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: child,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Notification Panel Overlay
            Obx(() {
              try {
                final notificationController = Get.find<NotificationController>();
                if (!notificationController.isPanelOpen.value) {
                  return const SizedBox.shrink();
                }
                
                return Positioned(
                  right: 16,
                  top: 80,
                  child: Material(
                    color: Colors.transparent,
                    elevation: 8,
                    child: NotificationPanel(),
                  ),
                );
              } catch (e) {
                return const SizedBox.shrink();
              }
            }),
            
            // Backdrop to close panel when clicking outside
            Obx(() {
              try {
                final notificationController = Get.find<NotificationController>();
                if (!notificationController.isPanelOpen.value) {
                  return const SizedBox.shrink();
                }
                
                return Positioned.fill(
                  child: GestureDetector(
                    onTap: () => notificationController.closePanel(),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.1),
                    ),
                  ),
                );
              } catch (e) {
                return const SizedBox.shrink();
              }
            }),
          ],
        );
      },
    );
  }

  Widget _buildSmallScreenMessage(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.desktop_windows, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 24),
              Text(
                'Desktop Required',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'This admin panel requires a desktop browser.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Please access from a computer with minimum screen width of 1024px.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

