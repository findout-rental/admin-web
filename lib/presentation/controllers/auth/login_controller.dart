import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/constants/storage_keys.dart';
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
  String? errorMessage;
  bool _isLoginInProgress =
      false; // Synchronous flag to prevent race conditions

  @override
  void onInit() {
    super.onInit();
    // Initialize dependencies after bindings are ready
    authRepository = Get.find<AuthRepository>();
    authController = Get.find<AuthController>();
    _loadSavedCredentials();
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

    errorMessage = null;

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
        errorMessage = 'Invalid mobile number or password. Please try again.';
        update();
      }
    } catch (e) {
      errorMessage = _getErrorMessage(e);
      update();
    } finally {
      _isLoginInProgress = false;
      isLoading.value = false;
      update();
    }
  }

  String _getErrorMessage(dynamic error) {
    // Error handling - removed print statements for production code
    // TODO: Use proper logging framework if needed

    if (error.toString().contains('network') ||
        error.toString().contains('connection')) {
      return 'Unable to connect. Please check your internet connection.';
    }
    if (error.toString().contains('401') ||
        error.toString().contains('unauthorized')) {
      return 'Invalid mobile number or password. Please try again.';
    }
    // Return more specific error message
    final errorStr = error.toString();
    if (errorStr.contains('FormatException') || errorStr.contains('parse')) {
      return 'Error parsing server response. Please contact support.';
    }
    return errorStr.length > 100
        ? 'Something went wrong. Please try again later.'
        : errorStr;
  }

  @override
  void onClose() {
    mobileNumberController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
