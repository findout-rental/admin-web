import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/user_detail.dart';
import '../../widgets/layout/app_scaffold.dart';

class UserFullProfilePage extends StatelessWidget {
  final UserDetail userDetail;

  const UserFullProfilePage({
    Key? key,
    required this.userDetail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'view_full_profile'.tr,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Get.back(),
              tooltip: 'back'.tr,
            ),
            const SizedBox(height: 16),

            // Header Section
            _buildHeader(context),
            const SizedBox(height: 32),

            // Personal Information
            _buildSection(
              context,
              'personal_information'.tr,
              [
                _buildInfoRow(context, 'full_name'.tr, userDetail.fullName),
                _buildInfoRow(context, 'mobile_number'.tr, userDetail.mobileNumber),
                if (userDetail.dateOfBirth != null)
                  _buildInfoRow(
                    context,
                    'date_of_birth'.tr,
                    DateFormat('MMMM dd, yyyy', Get.locale?.toString() ?? 'en_US').format(userDetail.dateOfBirth!),
                  ),
                _buildInfoRow(context, 'role'.tr, userDetail.role == 'tenant' ? 'tenant_role'.tr : 'owner_role'.tr),
                _buildInfoRow(context, 'status'.tr, userDetail.status.toUpperCase()),
                _buildInfoRow(
                  context,
                  'registration_date'.tr,
                  DateFormat('MMMM dd, yyyy', Get.locale?.toString() ?? 'en_US').format(userDetail.createdAt),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // ID Verification
            if (userDetail.idPhoto != null)
              _buildSection(
                context,
                'identity_verification'.tr,
                [
                  InkWell(
                    onTap: () => _showImageDialog(context, userDetail.idPhoto!),
                    child: Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxHeight: 400),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          userDetail.idPhoto!,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(24.0),
                                child: Icon(Icons.image_not_supported, size: 64),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            if (userDetail.idPhoto != null) const SizedBox(height: 32),

            // Account Balance
            _buildBalanceSection(context),
            const SizedBox(height: 32),

            // Activity Summary
            if (userDetail.activitySummary != null)
              _buildActivitySection(context),
            if (userDetail.activitySummary != null) const SizedBox(height: 32),

            // Account Statistics
            _buildStatisticsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: userDetail.personalPhoto != null && userDetail.personalPhoto!.isNotEmpty
              ? NetworkImage(userDetail.personalPhoto!)
              : null,
          child: userDetail.personalPhoto == null || userDetail.personalPhoto!.isEmpty
              ? const Icon(Icons.person, size: 60)
              : null,
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userDetail.fullName,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: userDetail.status == 'approved'
                          ? Colors.green
                          : userDetail.status == 'pending'
                              ? Colors.orange
                              : Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      userDetail.status.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      userDetail.role == 'tenant' ? 'tenant_role'.tr : 'owner_role'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'member_since'.tr + ' ${DateFormat('MMMM yyyy', Get.locale?.toString() ?? 'en_US').format(userDetail.createdAt)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceSection(BuildContext context) {
    return _buildSection(
      context,
      'account_balance'.tr,
      [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'current_balance'.tr,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'SYP ${NumberFormat('#,##0.00').format(userDetail.balance)}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivitySection(BuildContext context) {
    final summary = userDetail.activitySummary!;
    final isOwner = userDetail.role.toLowerCase() == 'owner';

    if (isOwner) {
      return _buildSection(
        context,
        'activity_summary'.tr,
        [
          _buildInfoRow(
            context,
            'total_apartments'.tr,
            '${summary.totalApartments ?? 0}',
          ),
          _buildInfoRow(
            context,
            'active_apartments'.tr,
            '${summary.activeApartments ?? 0}',
          ),
          _buildInfoRow(
            context,
            'total_bookings_received'.tr,
            '${summary.totalBookingsReceived ?? 0}',
          ),
          if (summary.averageRating != null)
            _buildInfoRow(
              context,
              'average_rating'.tr,
              '${summary.averageRating!.toStringAsFixed(1)} ⭐',
            ),
        ],
      );
    } else {
      return _buildSection(
        context,
        'activity_summary'.tr,
        [
          _buildInfoRow(
            context,
            'total_bookings'.tr,
            '${summary.totalBookings ?? 0}',
          ),
          _buildInfoRow(
            context,
            'active_bookings'.tr,
            '${summary.activeBookings ?? 0}',
          ),
          _buildInfoRow(
            context,
            'completed_bookings'.tr,
            '${summary.completedBookings ?? 0}',
          ),
          _buildInfoRow(
            context,
            'reviews_given'.tr,
            '${summary.reviewsGiven ?? 0}',
          ),
        ],
      );
    }
  }

  Widget _buildStatisticsSection(BuildContext context) {
    return _buildSection(
      context,
      'account_statistics'.tr,
      [
        _buildInfoRow(
          context,
          'active_bookings_count'.tr,
          '${userDetail.activeBookingsCount}',
        ),
        _buildInfoRow(
          context,
          'can_delete_account'.tr,
          userDetail.canDelete ? 'yes'.tr : 'no'.tr,
        ),
      ],
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: InteractiveViewer(
          child: Image.network(
            imageUrl,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Icon(Icons.image_not_supported, size: 64),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
