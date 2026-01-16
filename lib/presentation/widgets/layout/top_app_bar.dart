import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/theme/app_colors.dart';
import '../../controllers/auth/auth_controller.dart';
import '../../controllers/notification/notification_controller.dart';
import '../../controllers/settings/language_controller.dart';
import '../../controllers/settings/theme_controller.dart';

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
            // Language Toggle Button
            Obx(() {
              try {
                final languageController = Get.find<LanguageController>();
                final currentLang = languageController.selectedLanguage.value;
                return IconButton(
                  icon: Text(
                    currentLang == 'ar' ? 'EN' : 'AR',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  tooltip: currentLang == 'ar' ? 'switch_to_english'.tr : 'switch_to_arabic'.tr,
                  onPressed: languageController.isApplying.value
                      ? null
                      : () {
                          final newLang = currentLang == 'ar' ? 'en' : 'ar';
                          languageController.applyLanguage(newLang);
                        },
                );
              } catch (e) {
                // If controller not found, try to get current locale from GetX
                final currentLocale = Get.locale;
                final currentLang = currentLocale?.languageCode ?? 'en';
                return IconButton(
                  icon: Text(
                    currentLang == 'ar' ? 'EN' : 'AR',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  tooltip: currentLang == 'ar' ? 'switch_to_english'.tr : 'switch_to_arabic'.tr,
                  onPressed: () {
                    // Fallback: directly update locale if controller not available
                    final newLang = currentLang == 'ar' ? 'en' : 'ar';
                    final locale = newLang == 'ar' ? const Locale('ar', 'SA') : const Locale('en', 'US');
                    Get.updateLocale(locale);
                    Get.forceAppUpdate();
                    // Save to storage
                    final storage = GetStorage();
                    storage.write('language', newLang);
                  },
                );
              }
            }),
            
            // Theme Toggle Button
            Obx(() {
              try {
                final themeController = Get.find<ThemeController>();
                final isDark = themeController.selectedTheme.value == 'dark';
                return IconButton(
                  icon: Icon(
                    isDark ? Icons.light_mode : Icons.dark_mode,
                    color: Colors.white,
                  ),
                  tooltip: isDark ? 'switch_to_light_mode'.tr : 'switch_to_dark_mode'.tr,
                  onPressed: () {
                    final newTheme = isDark ? 'light' : 'dark';
                    themeController.applyTheme(newTheme);
                  },
                );
              } catch (e) {
                return const SizedBox.shrink();
              }
            }),
            
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
                      Get.snackbar('info'.tr, 'notifications_coming_soon'.tr);
                    },
                    tooltip: 'notifications'.tr,
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
                      PopupMenuItem(
                        value: 'settings',
                        child: Row(
                          children: [
                            const Icon(Icons.settings, size: 20),
                            const SizedBox(width: 12),
                            Text('settings'.tr),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem(
                        value: 'logout',
                        child: Row(
                          children: [
                            const Icon(Icons.logout, size: 20, color: AppColors.error),
                            const SizedBox(width: 12),
                            Text(
                              'logout'.tr,
                              style: const TextStyle(color: AppColors.error),
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
