import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/usecases/profile/update_language_usecase.dart';
import '../../controllers/settings/language_controller.dart';
import '../../widgets/layout/app_scaffold.dart';
import '../../widgets/layout/breadcrumb.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'language_settings'.tr,
      currentRoute: '/settings/language',
      breadcrumbs: [
        BreadcrumbItem(label: 'dashboard'.tr, route: '/dashboard'),
        BreadcrumbItem(label: 'settings'.tr, route: '/settings/profile'),
        BreadcrumbItem(label: 'language'.tr, route: '/settings/language'),
      ],
      child: GetBuilder<LanguageController>(
        init: LanguageController(
          updateLanguageUsecase: Get.find<UpdateLanguageUsecase>(),
        ),
        builder: (controller) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Page Header
                Text(
                  'language_settings'.tr,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'select_preferred_language'.tr,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 32),

                // Language Selection
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Obx(() {
                      final selectedLanguage =
                          controller.selectedLanguage.value;
                      return RadioGroup<String>(
                        groupValue: selectedLanguage,
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectLanguage(value);
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text('english'.tr),
                              subtitle: Text('english_us'.tr),
                              leading: const Radio<String>(
                                value: 'en',
                              ),
                              onTap: () {
                                controller.selectLanguage('en');
                              },
                            ),
                            const Divider(),
                            ListTile(
                              title: Text('arabic'.tr),
                              subtitle: Text('arabic_lang'.tr),
                              leading: const Radio<String>(
                                value: 'ar',
                              ),
                              onTap: () {
                                controller.selectLanguage('ar');
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 32),

                // Apply Button
                Obx(() => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isApplying.value
                            ? null
                            : () => controller.applyLanguage(
                                  controller.selectedLanguage.value,
                                ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: controller.isApplying.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(
                                'apply_language'.tr,
                                style: const TextStyle(fontSize: 16),
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
}
