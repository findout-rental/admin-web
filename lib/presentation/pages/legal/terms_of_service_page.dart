import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/layout/app_scaffold.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'terms_of_service'.tr,
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
                  'terms_of_service'.tr,
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
                  'terms_agreement'.tr,
                  'terms_agreement_desc'.tr,
                ),

                // Use License
                _buildSection(
                  context,
                  'terms_use_license'.tr,
                  'terms_use_license_desc'.tr,
                  children: [
                    _buildBulletPoint('terms_license_modify'.tr),
                    _buildBulletPoint('terms_license_commercial'.tr),
                    _buildBulletPoint('terms_license_reverse'.tr),
                    _buildBulletPoint('terms_license_remove'.tr),
                    _buildBulletPoint('terms_license_transfer'.tr),
                  ],
                ),

                // User Account
                _buildSection(
                  context,
                  'terms_user_account'.tr,
                  'terms_user_account_desc'.tr,
                  children: [
                    _buildBulletPoint('terms_account_accurate'.tr),
                    _buildBulletPoint('terms_account_update'.tr),
                    _buildBulletPoint('terms_account_security'.tr),
                    _buildBulletPoint('terms_account_responsibility'.tr),
                    _buildBulletPoint('terms_account_notify'.tr),
                  ],
                ),

                // Acceptable Use
                _buildSection(
                  context,
                  'terms_acceptable_use'.tr,
                  'terms_acceptable_use_desc'.tr,
                  children: [
                    _buildBulletPoint('terms_use_violate'.tr),
                    _buildBulletPoint('terms_use_infringe'.tr),
                    _buildBulletPoint('terms_use_harmful'.tr),
                    _buildBulletPoint('terms_use_interfere'.tr),
                    _buildBulletPoint('terms_use_unauthorized'.tr),
                  ],
                ),

                // Service Availability
                _buildSection(
                  context,
                  'terms_service_availability'.tr,
                  'terms_service_availability_desc'.tr,
                ),

                // Limitation of Liability
                _buildSection(
                  context,
                  'terms_limitation'.tr,
                  'terms_limitation_desc'.tr,
                ),

                // Indemnification
                _buildSection(
                  context,
                  'terms_indemnification'.tr,
                  'terms_indemnification_desc'.tr,
                ),

                // Termination
                _buildSection(
                  context,
                  'terms_termination'.tr,
                  'terms_termination_desc'.tr,
                ),

                // Changes to Terms
                _buildSection(
                  context,
                  'terms_changes'.tr,
                  'terms_changes_desc'.tr,
                ),

                // Governing Law
                _buildSection(
                  context,
                  'terms_governing_law'.tr,
                  'terms_governing_law_desc'.tr,
                ),

                // Contact Information
                _buildSection(
                  context,
                  'terms_contact'.tr,
                  'terms_contact_desc'.tr,
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

