import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';

class Sidebar extends StatefulWidget {
  final String currentRoute;

  const Sidebar({
    super.key,
    required this.currentRoute,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool _isCollapsed = false;

  final List<SidebarItem> _menuItems = [
    SidebarItem(
      icon: Icons.dashboard,
      label: 'Dashboard',
      route: '/dashboard',
    ),
    SidebarItem(
      icon: Icons.pending_actions,
      label: 'Pending Registrations',
      route: '/pending-registrations',
      badge: 0, // Will be updated dynamically
    ),
    SidebarItem(
      icon: Icons.people,
      label: 'All Users',
      route: '/users',
    ),
    SidebarItem(
      icon: Icons.apartment,
      label: 'All Apartments',
      route: '/apartments',
    ),
    SidebarItem(
      icon: Icons.calendar_today,
      label: 'All Bookings',
      route: '/bookings',
    ),
    SidebarItem(
      icon: Icons.settings,
      label: 'Settings',
      route: '/settings/profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: _isCollapsed ? 60 : 240,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Logo/Brand (when expanded)
          if (!_isCollapsed)
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.apartment,
                    color: Theme.of(context).colorScheme.primary,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'FindOut Admin',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(16),
              child: Icon(
                Icons.apartment,
                color: Theme.of(context).colorScheme.primary,
                size: 32,
              ),
            ),

          const Divider(height: 1),

          // Menu Items
          Expanded(
            child: ListView.builder(
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                final isActive = widget.currentRoute == item.route ||
                    widget.currentRoute.startsWith(item.route);

                return _buildMenuItem(item, isActive);
              },
            ),
          ),

          // Collapse Toggle Button
          Container(
            padding: const EdgeInsets.all(8),
            child: IconButton(
              icon: Icon(
                _isCollapsed ? Icons.chevron_right : Icons.chevron_left,
              ),
              onPressed: () {
                setState(() {
                  _isCollapsed = !_isCollapsed;
                });
              },
              tooltip: _isCollapsed ? 'Expand sidebar' : 'Collapse sidebar',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(SidebarItem item, bool isActive) {
    return InkWell(
      onTap: () {
        final currentRoute = Get.currentRoute;
        if (currentRoute != item.route) {
          Get.toNamed(item.route);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: EdgeInsets.symmetric(
          horizontal: _isCollapsed ? 8 : 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isActive
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1,
                )
              : null,
        ),
        child: Row(
          children: [
            Icon(
              item.icon,
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
              size: 24,
            ),
            if (!_isCollapsed) ...[
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  item.label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.normal,
                        color: isActive
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ),
              if (item.badge != null && item.badge! > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    item.badge.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class SidebarItem {
  final IconData icon;
  final String label;
  final String route;
  final int? badge;

  SidebarItem({
    required this.icon,
    required this.label,
    required this.route,
    this.badge,
  });
}
