import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../domain/usecases/profile/update_language_usecase.dart';

class LanguageController extends GetxController {
  final UpdateLanguageUsecase updateLanguageUsecase;
  final GetStorage storage = GetStorage();

  LanguageController({required this.updateLanguageUsecase});

  final selectedLanguage = 'en'.obs;
  final isApplying = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Load current language preference
    final savedLanguage = storage.read<String>(StorageKeys.language) ?? 'en';
    selectedLanguage.value = savedLanguage;
  }

  Future<void> applyLanguage(String language) async {
    if (selectedLanguage.value == language) return;

    isApplying.value = true;

    // Update locally first (this should always work)
    await storage.write(StorageKeys.language, language);
    selectedLanguage.value = language;

    // Update GetX locale - use the format that matches our translation keys
    final locale = language == 'ar' ? const Locale('ar', 'SA') : const Locale('en', 'US');
    Get.updateLocale(locale);
    
    // Force app update to ensure all widgets rebuild with new locale
    Get.forceAppUpdate();

    // Try to update on server (but don't block if it fails)
    try {
      await updateLanguageUsecase.execute(language);
      Get.snackbar('success'.tr, 'language_updated_successfully'.tr);
    } catch (e) {
      // Language change still works locally, just server update failed
      // Don't show error to user since the language change succeeded
      // Only log for debugging
      print('Failed to update language on server: $e');
    } finally {
      isApplying.value = false;
    }
  }

  void selectLanguage(String language) {
    selectedLanguage.value = language;
  }
}

