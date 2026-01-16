import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/validators.dart';
import '../../controllers/auth/forgot_password_controller.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgotPasswordController>(
      init: ForgotPasswordController(Get.find()),
      builder: (controller) {
        return Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 1024) {
                return _buildSmallScreenMessage(context);
              }

              return Row(
                children: [
                  // Left Panel - Branding (same as login)
                  Expanded(
                    child: _buildBrandingPanel(context),
                  ),
                  // Right Panel - Forgot Password Form
                  Expanded(
                    child: _buildForgotPasswordForm(context, controller),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSmallScreenMessage(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.desktop_windows, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              'desktop_required'.tr,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'desktop_required_message'.tr,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandingPanel(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_reset,
                size: 120,
                color: Colors.white,
              ),
              const SizedBox(height: 32),
              Text(
                'reset_password'.tr,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'reset_password_help'.tr,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white70,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordForm(
      BuildContext context, ForgotPasswordController controller) {
    return Container(
      padding: const EdgeInsets.all(48.0),
      child: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Obx(() {
              if (controller.isSuccess.value) {
                return _buildSuccessView(context, controller);
              }

              return Form(
                key: controller.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Back to Login
                    TextButton.icon(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back),
                      label: Text('back_to_login'.tr),
                      style: TextButton.styleFrom(
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Header
                    Text(
                      'forgot_password_title'.tr,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'forgot_password_description'.tr,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 48),

                    // Error Message
                    if (controller.errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red[200]!),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red[700], size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                controller.errorMessage!,
                                style: TextStyle(color: Colors.red[700], fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Mobile Number Field
                    TextFormField(
                      controller: controller.mobileNumberController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: 'mobile_number'.tr,
                        hintText: 'enter_mobile'.tr,
                        prefixIcon: const Icon(Icons.phone),
                        border: const OutlineInputBorder(),
                      ),
                      validator: Validators.mobileNumber,
                      onFieldSubmitted: (_) => controller.submitForgotPassword(),
                    ),
                    const SizedBox(height: 32),

                    // Submit Button
                    Obx(() => ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.submitForgotPassword,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(
                                  'send_reset_instructions'.tr,
                                  style: const TextStyle(fontSize: 16),
                                ),
                        )),
                    const SizedBox(height: 24),

                    // Back to Login Link
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text('remember_password'.tr),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessView(
      BuildContext context, ForgotPasswordController controller) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(
          Icons.check_circle,
          size: 80,
          color: Colors.green,
        ),
        const SizedBox(height: 24),
        Text(
          'instructions_sent'.tr,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'instructions_sent_message'.tr,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'check_messages'.tr,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 48),
        ElevatedButton(
          onPressed: () => Get.back(),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            minimumSize: const Size(double.infinity, 50),
          ),
          child: Text(
            'back_to_login'.tr,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
            controller.reset();
          },
          child: Text('send_to_another_number'.tr),
        ),
      ],
    );
  }
}

