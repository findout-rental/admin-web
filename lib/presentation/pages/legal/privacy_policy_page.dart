import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/layout/app_scaffold.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'privacy_policy'.tr,
      showSidebar: false,
      showNotificationIcon: false,
      showProfileIcon: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(48.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'privacy_policy'.tr,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${'last_updated'.tr}: ${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 32),

                // Introduction
                _buildSection(
                  context,
                  'introduction'.tr,
                  'privacy_introduction'.tr,
                ),

                // Information We Collect
                _buildSection(
                  context,
                  'privacy_info_we_collect'.tr,
                  'privacy_info_we_collect_desc'.tr,
                  children: [
                    _buildBulletPoint('privacy_info_personal'.tr),
                    _buildBulletPoint('privacy_info_credentials'.tr),
                    _buildBulletPoint('privacy_info_usage'.tr),
                    _buildBulletPoint('privacy_info_device'.tr),
                  ],
                ),

                // How We Use Your Information
                _buildSection(
                  context,
                  'privacy_how_we_use'.tr,
                  'privacy_how_we_use_desc'.tr,
                  children: [
                    _buildBulletPoint('privacy_use_provide'.tr),
                    _buildBulletPoint('privacy_use_notify'.tr),
                    _buildBulletPoint('privacy_use_support'.tr),
                    _buildBulletPoint('privacy_use_analysis'.tr),
                    _buildBulletPoint('privacy_use_monitor'.tr),
                    _buildBulletPoint('privacy_use_detect'.tr),
                  ],
                ),

                // Data Security
                _buildSection(
                  context,
                  'privacy_data_security'.tr,
                  'privacy_data_security_desc'.tr,
                ),

                // Data Retention
                _buildSection(
                  context,
                  'privacy_data_retention'.tr,
                  'privacy_data_retention_desc'.tr,
                ),

                // Your Rights
                _buildSection(
                  context,
                  'privacy_your_rights'.tr,
                  'privacy_your_rights_desc'.tr,
                  children: [
                    _buildBulletPoint('privacy_right_access'.tr),
                    _buildBulletPoint('privacy_right_correction'.tr),
                    _buildBulletPoint('privacy_right_deletion'.tr),
                    _buildBulletPoint('privacy_right_object'.tr),
                    _buildBulletPoint('privacy_right_restriction'.tr),
                    _buildBulletPoint('privacy_right_portability'.tr),
                  ],
                ),

                // Cookies
                _buildSection(
                  context,
                  'privacy_cookies'.tr,
                  'privacy_cookies_desc'.tr,
                ),

                // Changes to This Policy
                _buildSection(
                  context,
                  'privacy_changes'.tr,
                  'privacy_changes_desc'.tr,
                ),

                // Contact Us
                _buildSection(
                  context,
                  'privacy_contact'.tr,
                  'privacy_contact_desc'.tr,
                ),

                const SizedBox(height: 48),
                const Divider(),
                const SizedBox(height: 32),

                // Back Button
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back),
                    label: Text('go_back'.tr),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    String content, {
    List<Widget>? children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        if (children != null) ...[
          const SizedBox(height: 12),
          ...children,
        ],
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

