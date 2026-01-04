import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/constants/storage_keys.dart';

class ThemeController extends GetxController {
  final GetStorage storage = GetStorage();

  final selectedTheme = 'light'.obs; // 'light', 'dark', 'system'

  @override
  void onInit() {
    super.onInit();
    // Load current theme preference
    final savedTheme = storage.read<String>(StorageKeys.theme) ?? 'light';
    selectedTheme.value = savedTheme;
  }

  void selectTheme(String theme) {
    selectedTheme.value = theme;
  }

  Future<void> applyTheme(String theme) async {
    selectedTheme.value = theme;
    await storage.write(StorageKeys.theme, theme);

    // Update theme mode
    switch (theme) {
      case 'dark':
        Get.changeThemeMode(ThemeMode.dark);
        break;
      case 'light':
        Get.changeThemeMode(ThemeMode.light);
        break;
      case 'system':
        // System theme would require checking system preference
        // For now, default to light
        Get.changeThemeMode(ThemeMode.light);
        break;
    }

    Get.snackbar('Success', 'Theme updated successfully');
  }
}

