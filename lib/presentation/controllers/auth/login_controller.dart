import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../core/utils/app_logger.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'auth_controller.dart';

class LoginController extends GetxController {
  late final AuthRepository authRepository;
  late final AuthController authController;
  final GetStorage storage = GetStorage();

  // Form controllers
  final mobileNumberController = TextEditingController();
  final passwordController = TextEditingController();

  // Form key
  final formKey = GlobalKey<FormState>();

  // State
  final isPasswordVisible = false.obs;
  final rememberMe = false.obs;
  final isLoading = false.obs;
  final errorMessage = Rxn<String>();
  final currentLanguage = 'en'.obs; // Reactive language variable
  final currentTheme = 'light'.obs; // Reactive theme variable
  bool _isLoginInProgress =
      false; // Synchronous flag to prevent race conditions

  @override
  void onInit() {
    super.onInit();
    try {
      // Initialize dependencies after bindings are ready
      authRepository = Get.find<AuthRepository>();
      authController = Get.find<AuthController>();
      _loadSavedCredentials();
      _loadLanguagePreference();
      _loadThemePreference();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to initialize LoginController',
        error: e,
        stackTrace: stackTrace,
      );
      // Set default values to prevent crashes
      errorMessage.value = 'Initialization error. Please refresh the page.';
    }
  }

  void _loadLanguagePreference() {
    try {
      final savedLanguage = storage.read<String>(StorageKeys.language) ?? 'en';
      currentLanguage.value = savedLanguage;
    } catch (e) {
      // Use default language
      currentLanguage.value = 'en';
    }
  }

  void _loadThemePreference() {
    try {
      final savedTheme = storage.read<String>(StorageKeys.theme) ?? 'light';
      currentTheme.value = savedTheme;
      _applyTheme(savedTheme);
    } catch (e) {
      // Use default theme
      currentTheme.value = 'light';
    }
  }

  void _loadSavedCredentials() {
    final savedMobile = storage.read<String>('saved_mobile_number');
    final savedRememberMe = storage.read<bool>(StorageKeys.rememberMe) ?? false;

    if (savedMobile != null) {
      mobileNumberController.text = savedMobile;
      rememberMe.value = savedRememberMe;
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  Future<void> login() async {
    // Prevent concurrent calls using synchronous flag
    if (_isLoginInProgress || isLoading.value) {
      return;
    }

    // Set flags immediately to prevent race conditions
    _isLoginInProgress = true;
    isLoading.value = true;
    update();

    if (!formKey.currentState!.validate()) {
      _isLoginInProgress = false;
      isLoading.value = false;
      update();
      return;
    }

    errorMessage.value = null;

    try {
      final mobileNumber = mobileNumberController.text.trim();
      final password = passwordController.text;

      final success = await authController.login(mobileNumber, password);

      if (success) {
        // Save credentials if remember me is checked
        if (rememberMe.value) {
          storage.write('saved_mobile_number', mobileNumber);
          storage.write(StorageKeys.rememberMe, true);
        } else {
          storage.remove('saved_mobile_number');
          storage.remove(StorageKeys.rememberMe);
        }

        Get.offAllNamed('/dashboard');
      } else {
        errorMessage.value = 'invalid_credentials'.tr;
        update();
      }
    } catch (e) {
      errorMessage.value = _getErrorMessage(e);
    } finally {
      _isLoginInProgress = false;
      isLoading.value = false;
      update();
    }
  }

  String _getErrorMessage(dynamic error) {
    // Log error for debugging
    AppLogger.error(
      'Login error',
      error: error,
      stackTrace: StackTrace.current,
    );

    if (error.toString().contains('network') ||
        error.toString().contains('connection')) {
      return 'network_error'.tr;
    }
    if (error.toString().contains('401') ||
        error.toString().contains('unauthorized')) {
      return 'invalid_credentials'.tr;
    }
    // Return more specific error message
    final errorStr = error.toString();
    if (errorStr.contains('FormatException') || errorStr.contains('parse')) {
      return 'Error parsing server response. Please contact support.';
    }
    return errorStr.length > 100
        ? 'unknown_error'.tr
        : errorStr;
  }

  void changeLanguage(String language) {
    try {
      // Update reactive variable first
      currentLanguage.value = language;
      
      // Save language preference
      storage.write(StorageKeys.language, language);
      
      // Update GetX locale - use the exact format that matches our translations
      final locale = language == 'ar' 
          ? const Locale('ar', 'SA') 
          : const Locale('en', 'US');
      
      // Force GetX to update locale
      Get.updateLocale(locale);
      
      // Debug: Check if translations are available
      AppLogger.info('Changed language to: $language, locale: ${locale.toString()}');
      AppLogger.info('Translation test: ${'welcome_back'.tr}');
    } catch (e) {
      // Silently fail - language switching is optional
      AppLogger.error('Failed to change language', error: e);
    }
  }

  void toggleTheme() {
    try {
      final newTheme = currentTheme.value == 'light' ? 'dark' : 'light';
      currentTheme.value = newTheme;
      storage.write(StorageKeys.theme, newTheme);
      _applyTheme(newTheme);
    } catch (e) {
      AppLogger.error('Failed to toggle theme', error: e);
    }
  }

  void _applyTheme(String theme) {
    switch (theme) {
      case 'dark':
        Get.changeThemeMode(ThemeMode.dark);
        break;
      case 'light':
      default:
        Get.changeThemeMode(ThemeMode.light);
        break;
    }
  }

  @override
  void onClose() {
    mobileNumberController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
