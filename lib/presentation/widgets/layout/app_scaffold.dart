import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/responsive.dart';
import 'sidebar.dart';
import 'top_app_bar.dart';
import 'breadcrumb.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final List<BreadcrumbItem>? breadcrumbs;
  final List<Widget>? actions;
  final bool showSidebar;
  final String? currentRoute;

  const AppScaffold({
    super.key,
    required this.title,
    required this.child,
    this.breadcrumbs,
    this.actions,
    this.showSidebar = true,
    this.currentRoute,
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

        return Scaffold(
          appBar: TopAppBar(
            title: title,
            actions: actions,
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

