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

    try {
      // Update on server
      await updateLanguageUsecase.execute(language);

      // Save locally
      await storage.write(StorageKeys.language, language);
      selectedLanguage.value = language;

      // Update GetX locale
      final locale = language == 'ar' ? const Locale('ar', 'SA') : const Locale('en', 'US');
      Get.updateLocale(locale);

      Get.snackbar('Success', 'Language updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Unable to change language. Please try again.');
    } finally {
      isApplying.value = false;
    }
  }

  void selectLanguage(String language) {
    selectedLanguage.value = language;
  }
}

