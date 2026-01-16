import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/pending_registration.dart';
import '../../../domain/usecases/registration/get_pending_registrations_usecase.dart';
import '../../../domain/usecases/registration/approve_registration_usecase.dart';
import '../../../domain/usecases/registration/reject_registration_usecase.dart';
import '../../controllers/registration/pending_registrations_controller.dart';
import '../../widgets/layout/app_scaffold.dart';
import '../../widgets/layout/breadcrumb.dart';

class PendingRegistrationsPage extends StatelessWidget {
  const PendingRegistrationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'pending_registrations'.tr,
      currentRoute: '/pending-registrations',
      breadcrumbs: [
        BreadcrumbItem(label: 'dashboard'.tr, route: '/dashboard'),
        BreadcrumbItem(
            label: 'pending_registrations'.tr, route: '/pending-registrations'),
      ],
      child: GetBuilder<PendingRegistrationsController>(
        init: PendingRegistrationsController(
          getPendingRegistrationsUsecase:
              Get.find<GetPendingRegistrationsUsecase>(),
          approveRegistrationUsecase: Get.find<ApproveRegistrationUsecase>(),
          rejectRegistrationUsecase: Get.find<RejectRegistrationUsecase>(),
        ),
        builder: (controller) {
          return Column(
            children: [
              // Page Header
              _buildPageHeader(context, controller),

              // Toolbar
              _buildToolbar(context, controller),

              // Data Table
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value &&
                      controller.registrations.isEmpty) {
                    return _buildLoadingState();
                  }

                  if (controller.registrations.isEmpty) {
                    return _buildEmptyState(context, controller);
                  }

                  return _buildDataTable(context, controller);
                }),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPageHeader(
      BuildContext context, PendingRegistrationsController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Text(
                'pending_registrations'.tr,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                    ),
              ),
              const SizedBox(width: 12),
              Obx(() {
                final count = controller.registrations.length;
                if (count > 0) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '$count',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar(
      BuildContext context, PendingRegistrationsController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Column(
        children: [
          // Search Bar
          TextField(
            onChanged: controller.onSearchChanged,
            decoration: InputDecoration(
              hintText: 'search_by_name_or_mobile'.tr,
              prefixIcon: Icon(Icons.search, color: Theme.of(context).iconTheme.color?.withValues(alpha: 0.6)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Theme.of(context).dividerColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Theme.of(context).dividerColor),
              ),
              filled: true,
              fillColor: Theme.of(context).inputDecorationTheme.fillColor ?? Theme.of(context).cardColor,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 12),

          // Filters Row
          Row(
            children: [
              // Role Filter
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).inputDecorationTheme.fillColor ?? Theme.of(context).cardColor,
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Obx(() => DropdownButton<String>(
                        value: controller.selectedRole.value,
                        items: [
                          DropdownMenuItem(
                              value: 'all', child: Text('all_roles'.tr)),
                          DropdownMenuItem(
                              value: 'tenant', child: Text('tenants'.tr)),
                          DropdownMenuItem(
                              value: 'owner', child: Text('owners'.tr)),
                        ],
                        onChanged: controller.onRoleFilterChanged,
                        underline: const SizedBox.shrink(),
                        icon: Icon(Icons.keyboard_arrow_down,
                            color: Colors.grey[600]),
                        style: Theme.of(context).textTheme.bodyMedium,
                        isExpanded: true,
                      )),
                ),
              ),
              const SizedBox(width: 12),

              // Sort Dropdown
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).inputDecorationTheme.fillColor ?? Theme.of(context).cardColor,
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Obx(() => DropdownButton<String>(
                        value: controller.selectedSort.value,
                        items: [
                          DropdownMenuItem(
                              value: 'newest', child: Text('newest_first'.tr)),
                          DropdownMenuItem(
                              value: 'oldest', child: Text('oldest_first'.tr)),
                          DropdownMenuItem(
                              value: 'name', child: Text('name_az'.tr)),
                        ],
                        onChanged: controller.onSortChanged,
                        underline: const SizedBox.shrink(),
                        icon: Icon(Icons.keyboard_arrow_down,
                            color: Colors.grey[600]),
                        style: Theme.of(context).textTheme.bodyMedium,
                        isExpanded: true,
                      )),
                ),
              ),
              const SizedBox(width: 8),

              // Refresh Button
              Obx(() => IconButton(
                    icon: controller.isLoading.value
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(Icons.refresh, color: Colors.grey[700]),
                    onPressed:
                        controller.isLoading.value ? null : controller.refresh,
                    tooltip: 'refresh'.tr,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      padding: const EdgeInsets.all(10),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[300],
            ),
            title: Container(
              height: 16,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            subtitle: Container(
              margin: const EdgeInsets.only(top: 8),
              height: 12,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(
      BuildContext context, PendingRegistrationsController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            'all_caught_up'.tr,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'no_pending_registrations'.tr,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(
      BuildContext context, PendingRegistrationsController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.separated(
                itemCount: controller.registrations.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final reg = controller.registrations[index];
                  return _buildRegistrationCard(context, controller, reg);
                },
              );
            }),
          ),
          Obx(() => _buildPagination(context, controller)),
        ],
      ),
    );
  }

  Widget _buildRegistrationCard(BuildContext context,
      PendingRegistrationsController controller, PendingRegistration reg) {
    return InkWell(
      onTap: () => Get.toNamed('/registration-detail/${reg.id}'),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Photo
            CircleAvatar(
              radius: 28,
              backgroundImage:
                  reg.personalPhoto != null && reg.personalPhoto!.isNotEmpty
                      ? NetworkImage(reg.personalPhoto!)
                      : null,
              child: reg.personalPhoto == null || reg.personalPhoto!.isEmpty
                  ? Icon(Icons.person, size: 28, color: Colors.grey[600])
                  : null,
            ),
            const SizedBox(width: 16),

            // Name & Mobile
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reg.fullName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reg.mobileNumber,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Role
            Expanded(
              flex: 2,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: reg.role == 'tenant'
                      ? Colors.blue.withValues(alpha: 0.1)
                      : Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  reg.role.toUpperCase(),
                  style: TextStyle(
                    color: reg.role == 'tenant' ? Colors.blue : Colors.green,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // Date
            Expanded(
              flex: 2,
              child: Text(
                DateFormat('MMM dd, yyyy').format(reg.createdAt),
                style: const TextStyle(fontSize: 13),
              ),
            ),

            // Status
            Expanded(
              flex: 2,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'pending'.tr,
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // Actions
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.check_circle,
                      color: Colors.green[600], size: 22),
                  onPressed: () => _showApproveDialog(context, controller, reg),
                  tooltip: 'quick_approve'.tr,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.green[50],
                    padding: const EdgeInsets.all(8),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: Icon(Icons.cancel, color: Colors.red[600], size: 22),
                  onPressed: () => _showRejectDialog(context, controller, reg),
                  tooltip: 'quick_reject'.tr,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.red[50],
                    padding: const EdgeInsets.all(8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPagination(
      BuildContext context, PendingRegistrationsController controller) {
    final pagination = controller.pagination.value;
    if (pagination == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            () {
              final registrationsCount = controller.registrations.length;
              final start = pagination.totalItems == 0
                  ? 0
                  : ((pagination.currentPage - 1) * pagination.perPage) + 1;
              final end = pagination.totalItems == 0
                  ? 0
                  : ((pagination.currentPage - 1) * pagination.perPage + registrationsCount).clamp(0, pagination.totalItems);
              return '${'showing'.tr} $start-$end ${'of'.tr} ${pagination.totalItems}';
            }(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.first_page),
                onPressed: pagination.hasPreviousPage
                    ? () => controller.goToPage(1)
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: pagination.hasPreviousPage
                    ? () => controller.goToPage(pagination.currentPage - 1)
                    : null,
              ),
              ...List.generate(
                pagination.totalPages.clamp(0, 5),
                (index) {
                  final page = index + 1;
                  return TextButton(
                    onPressed: () => controller.goToPage(page),
                    style: TextButton.styleFrom(
                      backgroundColor: page == pagination.currentPage
                          ? Theme.of(context).colorScheme.primary
                          : null,
                      foregroundColor:
                          page == pagination.currentPage ? Colors.white : null,
                    ),
                    child: Text(page.toString()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: pagination.hasNextPage
                    ? () => controller.goToPage(pagination.currentPage + 1)
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.last_page),
                onPressed: pagination.hasNextPage
                    ? () => controller.goToPage(pagination.totalPages)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showApproveDialog(
    BuildContext context,
    PendingRegistrationsController controller,
    PendingRegistration registration,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('approve_registration'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${'name'.tr}: ${registration.fullName}'),
            Text('${'role'.tr}: ${registration.role.toUpperCase()}'),
            Text('${'mobile'.tr}: ${registration.mobileNumber}'),
            const SizedBox(height: 16),
            Text('user_will_be_notified_and_access'.tr),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.approveRegistration(registration.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: Text('approve'.tr),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(
    BuildContext context,
    PendingRegistrationsController controller,
    PendingRegistration registration,
  ) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('reject_registration'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${'name'.tr}: ${registration.fullName}'),
            Text('${'role'.tr}: ${registration.role.toUpperCase()}'),
            Text('${'mobile'.tr}: ${registration.mobileNumber}'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                labelText: 'reason_for_rejection'.tr,
                hintText: 'enter_reason'.tr,
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
              maxLength: 500,
            ),
            const SizedBox(height: 8),
            Text(
              'user_will_be_notified'.tr,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.rejectRegistration(
                registration.id,
                reason: reasonController.text.isEmpty
                    ? null
                    : reasonController.text,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('reject'.tr),
          ),
        ],
      ),
    );
  }
}
