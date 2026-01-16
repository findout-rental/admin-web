import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../controllers/auth/auth_controller.dart';
import '../../controllers/notification/notification_controller.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showNotificationIcon;
  final bool showProfileIcon;

  const TopAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showNotificationIcon = true,
    this.showProfileIcon = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.apartment,
                size: 28,
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          actions: [
            // Notifications Icon with Badge
            if (showNotificationIcon)
              Obx(() {
                try {
                  final notificationController =
                      Get.find<NotificationController>();
                  final unreadCount = notificationController.unreadCount.value;

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined),
                        onPressed: () {
                          notificationController.togglePanel();
                        },
                        tooltip: 'Notifications',
                      ),
                      if (unreadCount > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              unreadCount > 99 ? '99+' : '$unreadCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                } catch (e) {
                  // Notification controller not available (e.g., not logged in)
                  return IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {
                      Get.snackbar('Info', 'Notifications feature coming soon');
                    },
                    tooltip: 'Notifications',
                  );
                }
              }),

            // Profile Menu
            if (showProfileIcon)
              Obx(() {
                final authController = Get.find<AuthController>();
                final user = authController.currentUser;

                return PopupMenuButton<String>(
                  icon: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: user != null &&
                            user.personalPhoto.isNotEmpty &&
                            user.personalPhoto != ''
                        ? ClipOval(
                            child: Image.network(
                              user.personalPhoto,
                              width: 32,
                              height: 32,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  size: 20,
                                  color: Theme.of(context).colorScheme.primary,
                                );
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Icon(
                                  Icons.person,
                                  size: 20,
                                  color: Theme.of(context).colorScheme.primary,
                                );
                              },
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                  ),
                  onSelected: (value) {
                    final controller = Get.find<AuthController>();
                    switch (value) {
                      case 'profile':
                        Get.toNamed('/settings/profile');
                        break;
                      case 'settings':
                        Get.toNamed('/settings/profile');
                        break;
                      case 'logout':
                        controller.logout();
                        break;
                    }
                  },
                  itemBuilder: (context) {
                    final authController = Get.find<AuthController>();
                    final user = authController.currentUser;

                    return [
                      if (user != null)
                        PopupMenuItem(
                          value: 'profile',
                          child: Row(
                            children: [
                              const Icon(Icons.person, size: 20),
                              const SizedBox(width: 12),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      user.fullName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      user.role.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (user != null) const PopupMenuDivider(),
                      const PopupMenuItem(
                        value: 'settings',
                        child: Row(
                          children: [
                            Icon(Icons.settings, size: 20),
                            SizedBox(width: 12),
                            Text('Settings'),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem(
                        value: 'logout',
                        child: Row(
                          children: [
                            Icon(Icons.logout, size: 20, color: AppColors.error),
                            SizedBox(width: 12),
                            Text(
                              'Logout',
                              style: TextStyle(color: AppColors.error),
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                );
              }),

            // Custom actions
            if (actions != null) ...actions!,

            const SizedBox(width: 8),
          ],
        ),
      ],
    );
  }
}
