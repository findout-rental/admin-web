import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../domain/usecases/profile/get_profile_usecase.dart';
import '../../../domain/usecases/profile/update_profile_usecase.dart';
import '../../../domain/usecases/profile/upload_photo_usecase.dart';
import '../../controllers/settings/profile_controller.dart';
import '../../controllers/auth/auth_controller.dart';
import '../../widgets/layout/app_scaffold.dart';
import '../../widgets/layout/breadcrumb.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'profile_settings'.tr,
      currentRoute: '/settings/profile',
      breadcrumbs: [
        BreadcrumbItem(label: 'dashboard'.tr, route: '/dashboard'),
        BreadcrumbItem(label: 'settings'.tr, route: '/settings/profile'),
        BreadcrumbItem(label: 'profile'.tr, route: '/settings/profile'),
      ],
      child: GetBuilder<ProfileController>(
        init: ProfileController(
          getProfileUsecase: Get.find<GetProfileUsecase>(),
          updateProfileUsecase: Get.find<UpdateProfileUsecase>(),
          uploadPhotoUsecase: Get.find<UploadPhotoUsecase>(),
        ),
        builder: (controller) {
          return Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Page Header
                  Text(
                    'profile_settings'.tr,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'manage_profile_info'.tr,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 32),

                  // Profile Photo Section
                  _buildPhotoSection(context, controller),
                  const SizedBox(height: 32),

                  // Personal Information Section
                  _buildPersonalInfoSection(context, controller),
                  const SizedBox(height: 32),

                  // Account Information Section
                  _buildAccountInfoSection(context),
                  const SizedBox(height: 32),

                  // Action Buttons
                  _buildActionButtons(context, controller),
                ],
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildPhotoSection(BuildContext context, ProfileController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'profile_photo'.tr,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            Stack(
              children: [
                Obx(() {
                  final photoUrl = controller.selectedPhotoUrl.value ??
                      (controller.originalPhoto.value.isNotEmpty
                          ? controller.originalPhoto.value
                          : null);
                  
                  return CircleAvatar(
                    radius: 75,
                    backgroundImage: photoUrl != null
                        ? NetworkImage(photoUrl)
                        : null,
                    child: photoUrl == null
                        ? Icon(
                            Icons.person,
                            size: 75,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                  );
                }),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      onPressed: controller.pickImage,
                      tooltip: 'change_photo'.tr,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (controller.selectedPhoto.value != null)
              Obx(() => controller.isUploadingPhoto.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: controller.uploadPhoto,
                      child: Text('upload_photo'.tr),
                    )),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection(
      BuildContext context, ProfileController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'personal_information'.tr,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controller.firstNameController,
              decoration: InputDecoration(
                labelText: 'first_name'.tr,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.lastNameController,
              decoration: InputDecoration(
                labelText: 'last_name'.tr,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountInfoSection(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) {
        final user = authController.currentUser;
        if (user == null) return const SizedBox.shrink();

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'account_information'.tr,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 24),
                _buildInfoRow(
                  context,
                  'email'.tr,
                  user.mobileNumber, // Using mobile number as email equivalent
                  isReadOnly: true,
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  context,
                  'role'.tr,
                  user.role.toUpperCase(),
                  isReadOnly: true,
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  context,
                  'account_created'.tr,
                  DateFormat('MMM dd, yyyy').format(user.createdAt),
                  isReadOnly: true,
                ),
                if (user.mobileNumber.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'note_contact_admin'.tr,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    bool isReadOnly = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 150,
          child: Text(
            '$label:',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isReadOnly ? Colors.grey[600] : null,
                ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isReadOnly ? Colors.grey[600] : null,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
      BuildContext context, ProfileController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Obx(() => OutlinedButton(
              onPressed: controller.hasChanges()
                  ? controller.cancelChanges
                  : null,
              child: Text('cancel'.tr),
            )),
        const SizedBox(width: 16),
        Obx(() => ElevatedButton(
              onPressed: controller.hasChanges() && !controller.isSaving.value
                  ? controller.saveChanges
                  : null,
              child: controller.isSaving.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text('save_changes'.tr),
            )),
      ],
    );
  }
}
