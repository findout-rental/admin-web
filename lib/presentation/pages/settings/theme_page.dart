import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/settings/theme_controller.dart';
import '../../widgets/layout/app_scaffold.dart';
import '../../widgets/layout/breadcrumb.dart';
import '../../../core/theme/app_colors.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Theme Settings',
      currentRoute: '/settings/theme',
      breadcrumbs: [
        BreadcrumbItem(label: 'Dashboard', route: '/dashboard'),
        BreadcrumbItem(label: 'Settings', route: '/settings/profile'),
        BreadcrumbItem(label: 'Theme', route: '/settings/theme'),
      ],
      child: GetBuilder<ThemeController>(
        init: ThemeController(),
        builder: (controller) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Page Header
                Text(
                  'Theme Settings',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose your preferred theme',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 32),

                // Theme Selection
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Obx(() {
                      final selectedTheme = controller.selectedTheme.value;
                      return RadioGroup<String>(
                        groupValue: selectedTheme,
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectTheme(value);
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: const Text('Light Mode'),
                              subtitle: const Text('Classic bright theme'),
                              leading: const Radio<String>(
                                value: 'light',
                              ),
                              trailing: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onTap: () {
                                controller.selectTheme('light');
                              },
                            ),
                            const Divider(),
                            ListTile(
                              title: const Text('Dark Mode'),
                              subtitle: const Text(
                                  'Easy on the eyes, reduces eye strain'),
                              leading: const Radio<String>(
                                value: 'dark',
                              ),
                              trailing: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceDark,
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onTap: () {
                                controller.selectTheme('dark');
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 32),

                // Live Preview
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Live Preview',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 16),
                        Obx(() =>
                            _buildPreview(controller.selectedTheme.value)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Apply Button
                Obx(() => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => controller.applyTheme(
                          controller.selectedTheme.value,
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Apply Theme',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPreview(String theme) {
    final isDark = theme == 'dark';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.blue[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.dashboard,
                  color: isDark ? Colors.white : Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 12,
                      width: 100,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[700] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 8,
                      width: 60,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
