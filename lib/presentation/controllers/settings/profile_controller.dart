import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker_web/image_picker_web.dart';
import '../../../domain/usecases/profile/get_profile_usecase.dart';
import '../../../domain/usecases/profile/update_profile_usecase.dart';
import '../../../domain/usecases/profile/upload_photo_usecase.dart';
import '../../../core/constants/api_constants.dart';
import '../../controllers/auth/auth_controller.dart';

class ProfileController extends GetxController {
  final GetProfileUsecase getProfileUsecase;
  final UpdateProfileUsecase updateProfileUsecase;
  final UploadPhotoUsecase uploadPhotoUsecase;

  ProfileController({
    required this.getProfileUsecase,
    required this.updateProfileUsecase,
    required this.uploadPhotoUsecase,
  });

  // State
  final isLoading = false.obs;
  final isUploadingPhoto = false.obs;
  final isSaving = false.obs;

  // Form fields
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final originalFirstName = ''.obs;
  final originalLastName = ''.obs;
  final originalPhoto = ''.obs;
  final selectedPhoto = Rxn<Uint8List>();
  final selectedPhotoUrl = Rxn<String>();

  // Error
  String? errorMessage;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    errorMessage = null;

    try {
      final response = await getProfileUsecase.execute();
      final user = response['data']?['user'] as Map<String, dynamic>? ?? response;

      originalFirstName.value = user['first_name'] as String? ?? '';
      originalLastName.value = user['last_name'] as String? ?? '';
      originalPhoto.value = user['personal_photo'] as String? ?? '';

      firstNameController.text = originalFirstName.value;
      lastNameController.text = originalLastName.value;
    } catch (e) {
      errorMessage = 'Unable to load profile. Please try again.';
      Get.snackbar('Error', errorMessage!);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    try {
      final image = await ImagePickerWeb.getImageAsBytes();
      if (image != null) {
        selectedPhoto.value = image;
        // Convert to data URL for preview
        final base64 = base64Encode(image);
        selectedPhotoUrl.value = 'data:image/jpeg;base64,$base64';
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image. Please try again.');
    }
  }

  Future<void> uploadPhoto() async {
    if (selectedPhoto.value == null) return;

    isUploadingPhoto.value = true;

    try {
      final response = await uploadPhotoUsecase.execute(selectedPhoto.value!);
      final user = response['data']?['user'] as Map<String, dynamic>? ?? response;
      final newPhotoUrl = user['personal_photo'] as String? ?? '';
      
      // Convert relative URL to full URL if needed
      String fullPhotoUrl = newPhotoUrl;
      if (newPhotoUrl.isNotEmpty && !newPhotoUrl.startsWith('http')) {
        // If it's a relative path, prepend base URL (without /api)
        final baseUrl = ApiConstants.baseUrl.replaceAll('/api', '');
        fullPhotoUrl = newPhotoUrl.startsWith('/') 
            ? '$baseUrl$newPhotoUrl' 
            : '$baseUrl/$newPhotoUrl';
      }
      
      originalPhoto.value = fullPhotoUrl;
      
      // Update auth controller
      final authController = Get.find<AuthController>();
      await authController.checkAuthStatus();

      // Clear selected photo - the originalPhoto will now show the uploaded photo
      selectedPhoto.value = null;
      selectedPhotoUrl.value = null;

      Get.snackbar('success'.tr, 'photo_updated_successfully'.tr);
    } catch (e) {
      Get.snackbar('error'.tr, 'failed_to_upload_photo'.tr);
    } finally {
      isUploadingPhoto.value = false;
    }
  }

  Future<void> saveChanges() async {
    if (!hasChanges()) return;

    isSaving.value = true;
    errorMessage = null;

    try {
      // Upload photo first if changed
      if (selectedPhoto.value != null) {
        await uploadPhoto();
      }

      // Update profile
      final response = await updateProfileUsecase.execute(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
      );

      final user = response['data']?['user'] as Map<String, dynamic>? ?? response;
      originalFirstName.value = user['first_name'] as String? ?? '';
      originalLastName.value = user['last_name'] as String? ?? '';

      // Update auth controller
      final authController = Get.find<AuthController>();
      await authController.checkAuthStatus();

      Get.snackbar('success'.tr, 'profile_updated_successfully'.tr);
    } catch (e) {
      errorMessage = 'Failed to update profile. Please try again.';
      Get.snackbar('Error', errorMessage!);
    } finally {
      isSaving.value = false;
    }
  }

  void cancelChanges() {
    firstNameController.text = originalFirstName.value;
    lastNameController.text = originalLastName.value;
    selectedPhoto.value = null;
    selectedPhotoUrl.value = null;
  }

  bool hasChanges() {
    return firstNameController.text.trim() != originalFirstName.value ||
        lastNameController.text.trim() != originalLastName.value ||
        selectedPhoto.value != null;
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.onClose();
  }
}

