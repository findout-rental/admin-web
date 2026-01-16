import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/repositories/auth_repository.dart';

class ForgotPasswordController extends GetxController {
  final AuthRepository authRepository;

  ForgotPasswordController(this.authRepository);

  final mobileNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;
  final isSuccess = false.obs;
  String? errorMessage;

  Future<void> submitForgotPassword() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    errorMessage = null;
    isLoading.value = true;
    update();

    try {
      await authRepository.forgotPassword(mobileNumberController.text.trim());
      isSuccess.value = true;
    } catch (e) {
      errorMessage = _getErrorMessage(e);
    } finally {
      isLoading.value = false;
      update();
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('network') ||
        error.toString().contains('connection')) {
      return 'Unable to connect. Please check your internet connection.';
    }
    if (error.toString().contains('404') ||
        error.toString().contains('not found')) {
      return 'Mobile number not found. Please check and try again.';
    }
    return 'Unable to process request. Please try again later.';
  }

  void reset() {
    mobileNumberController.clear();
    isSuccess.value = false;
    errorMessage = null;
    update();
  }

  @override
  void onClose() {
    mobileNumberController.dispose();
    super.onClose();
  }
}

