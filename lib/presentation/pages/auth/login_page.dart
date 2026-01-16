import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth/login_controller.dart';
import '../../../core/utils/validators.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized
    try {
      if (!Get.isRegistered<LoginController>()) {
        Get.put(LoginController());
      }
    } catch (e) {
      // Return error widget instead of crashing
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $e'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Get.offAllNamed('/login'),
                child: Text('retry'.tr),
              ),
            ],
          ),
        ),
      );
    }
    
    final controller = Get.find<LoginController>();
    
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Show message if screen is too small
          if (constraints.maxWidth < 1024) {
            return _buildSmallScreenMessage(context);
          }

          return Row(
            children: [
              // Left Panel - Branding (50%)
              Expanded(
                child: _buildBrandingPanel(context),
              ),
              // Right Panel - Login Form (50%)
              Expanded(
                child: _buildLoginForm(context, controller),
              ),
            ],
          );
        },
      ),
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
              'Desktop Required',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'This admin panel requires a desktop browser.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Please access from a computer with minimum screen width of 1024px.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
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
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              const Icon(
                Icons.apartment,
                size: 120,
                color: Colors.white,
              ),
              const SizedBox(height: 32),
              // Headline
              Text(
                'app_name'.tr,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              // Subheadline
              Text(
                'app_tagline'.tr,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white70,
                    ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              // Version
              Text(
                'version'.tr,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white60,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, LoginController controller) {
    return Container(
      padding: const EdgeInsets.all(48.0),
      child: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Text(
                    'welcome_back'.tr,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'sign_in_to_admin'.tr,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 48),

                  // Error Message
                  Obx(() {
                    final error = controller.errorMessage.value;
                    if (error != null && error.isNotEmpty) {
                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red[200]!),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.error_outline,
                                    color: Colors.red[700], size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    error,
                                    style: TextStyle(
                                        color: Colors.red[700], fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  }),

                  // Mobile Number Field
                  TextFormField(
                    controller: controller.mobileNumberController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    textDirection: TextDirection.ltr, // Force LTR for phone numbers
                    decoration: InputDecoration(
                      labelText: 'mobile_number'.tr,
                      hintText: 'enter_mobile'.tr,
                      prefixIcon: const Icon(Icons.phone),
                      border: const OutlineInputBorder(),
                    ),
                    validator: Validators.mobileNumber,
                  ),
                  const SizedBox(height: 24),

                  // Password Field
                  Obx(() => TextFormField(
                        controller: controller.passwordController,
                        obscureText: !controller.isPasswordVisible.value,
                        textInputAction: TextInputAction.done,
                        // Removed onFieldSubmitted - Enter key will focus the button
                        // User can then press Enter again or click the button
                        decoration: InputDecoration(
                          labelText: 'password'.tr,
                          hintText: 'enter_password'.tr,
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: controller.togglePasswordVisibility,
                          ),
                          border: const OutlineInputBorder(),
                        ),
                        validator: Validators.required,
                      )),
                  const SizedBox(height: 16),

                  // Remember Me & Forgot Password
                  Row(
                    children: [
                      Obx(() => Checkbox(
                            value: controller.rememberMe.value,
                            onChanged: controller.toggleRememberMe,
                          )),
                      Text('keep_signed_in'.tr),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Get.toNamed('/forgot-password');
                        },
                        child: Text('forgot_password'.tr),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Login Button
                  Obx(() => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.login,
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
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text(
                                'sign_in'.tr,
                                style: const TextStyle(fontSize: 16),
                              ),
                      )),
                  const SizedBox(height: 32),

                  // Language Selector and Theme Toggle
                  Obx(() {
                    final isEnglish = controller.currentLanguage.value == 'en';
                    final isLight = controller.currentTheme.value == 'light';
                    
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            controller.changeLanguage('en');
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: isEnglish 
                                ? Theme.of(context).colorScheme.primary 
                                : Colors.grey[600],
                          ),
                          child: Text(
                            'english'.tr,
                            style: TextStyle(
                              fontWeight: isEnglish ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                        Text(
                          '|',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        TextButton(
                          onPressed: () {
                            controller.changeLanguage('ar');
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: !isEnglish 
                                ? Theme.of(context).colorScheme.primary 
                                : Colors.grey[600],
                          ),
                          child: Text(
                            'arabic'.tr,
                            style: TextStyle(
                              fontWeight: !isEnglish ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                        Text(
                          '|',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        IconButton(
                          onPressed: controller.toggleTheme,
                          icon: Icon(
                            isLight ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          tooltip: isLight ? 'dark_mode'.tr : 'light_mode'.tr,
                        ),
                      ],
                    );
                  }),

                  // Footer Links
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Get.toNamed('/privacy-policy');
                        },
                        child: Text('privacy_policy'.tr),
                      ),
                      const Text('|'),
                      TextButton(
                        onPressed: () {
                          Get.toNamed('/terms-of-service');
                        },
                        child: Text('terms_of_service'.tr),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
