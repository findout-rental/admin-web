import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/user_detail.dart';
import '../../../domain/usecases/user/get_all_users_usecase.dart';
import '../../../domain/usecases/user/get_user_detail_usecase.dart';
import '../../../domain/usecases/user/delete_user_usecase.dart';
import '../../../domain/usecases/user/deposit_money_usecase.dart';
import '../../../domain/usecases/user/withdraw_money_usecase.dart';
import '../../../domain/usecases/user/get_transaction_history_usecase.dart';
import '../../controllers/user/all_users_controller.dart';
import '../../widgets/layout/app_scaffold.dart';
import '../../widgets/layout/breadcrumb.dart';
import '../../widgets/panels/transaction_history_panel.dart';
import '../../widgets/dialogs/send_message_dialog.dart';
import 'user_full_profile_page.dart';

class AllUsersPage extends StatelessWidget {
  const AllUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'all_users'.tr,
      currentRoute: '/users',
      breadcrumbs: [
        BreadcrumbItem(label: 'dashboard'.tr, route: '/dashboard'),
        BreadcrumbItem(label: 'all_users'.tr, route: '/users'),
      ],
      child: GetBuilder<AllUsersController>(
        init: AllUsersController(
          getAllUsersUsecase: Get.find<GetAllUsersUsecase>(),
          getUserDetailUsecase: Get.find<GetUserDetailUsecase>(),
          deleteUserUsecase: Get.find<DeleteUserUsecase>(),
          depositMoneyUsecase: Get.find<DepositMoneyUsecase>(),
          withdrawMoneyUsecase: Get.find<WithdrawMoneyUsecase>(),
          getTransactionHistoryUsecase: Get.find<GetTransactionHistoryUsecase>(),
        ),
        builder: (controller) {
          return Stack(
            children: [
              Column(
                children: [
                  // Page Header
                  _buildPageHeader(context, controller),
                  
                  // Master-Detail Layout
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Panel - User List (40%)
                        Expanded(
                          flex: 2,
                          child: _buildUserListPanel(context, controller),
                        ),
                        
                        // Right Panel - User Detail (60%)
                        Expanded(
                          flex: 3,
                          child: _buildUserDetailPanel(context, controller),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              // Transaction History Panel (Slide-out from right)
              Obx(() {
                if (!controller.isTransactionHistoryPanelOpen.value ||
                    controller.userDetail.value == null) {
                  return const SizedBox.shrink();
                }
                
                return Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () => controller.closeTransactionHistoryPanel(),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.3),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {}, // Prevent closing when clicking panel
                          child: TransactionHistoryPanel(
                            userName: controller.userDetail.value!.fullName,
                            currentBalance: controller.userDetail.value!.balance,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPageHeader(BuildContext context, AllUsersController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'all_users'.tr,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Obx(() {
                final stats = controller.statistics.value;
                if (stats != null) {
                  return Text(
                    '${'total'.tr}: ${stats.total} ${'users'.tr.toLowerCase()} (${stats.approved} ${'approved'.tr}, ${stats.pending} ${'pending'.tr}, ${stats.rejected} ${'rejected'.tr})',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
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

  Widget _buildUserListPanel(BuildContext context, AllUsersController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          right: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Column(
        children: [
          // Toolbar
          _buildListToolbar(context, controller),
          
          // User List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.users.isEmpty) {
                return _buildListLoadingState();
              }
              
              if (controller.users.isEmpty) {
                return _buildListEmptyState(context);
              }
              
              return _buildUserList(context, controller);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildListToolbar(BuildContext context, AllUsersController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Column(
        children: [
          // Search Bar
          TextField(
            onChanged: controller.onSearchChanged,
            decoration: InputDecoration(
              hintText: 'search_users'.tr,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 12),
          
          // Filter Tabs
          Obx(() {
            final stats = controller.statistics.value;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterTab(
                    context,
                    'all'.tr,
                    stats?.total ?? 0,
                    controller.selectedStatus.value == 'all',
                    () => controller.onStatusFilterChanged('all'),
                  ),
                  _buildFilterTab(
                    context,
                    'approved'.tr,
                    stats?.approved ?? 0,
                    controller.selectedStatus.value == 'approved',
                    () => controller.onStatusFilterChanged('approved'),
                  ),
                  _buildFilterTab(
                    context,
                    'pending'.tr,
                    stats?.pending ?? 0,
                    controller.selectedStatus.value == 'pending',
                    () => controller.onStatusFilterChanged('pending'),
                  ),
                  _buildFilterTab(
                    context,
                    'rejected'.tr,
                    stats?.rejected ?? 0,
                    controller.selectedStatus.value == 'rejected',
                    () => controller.onStatusFilterChanged('rejected'),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 12),
          
          // Role and Sort Filters
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Obx(() => DropdownButton<String>(
                        value: controller.selectedRole.value,
                        items: [
                          DropdownMenuItem(value: 'all', child: Text('all_roles'.tr)),
                          DropdownMenuItem(value: 'tenant', child: Text('tenants'.tr)),
                          DropdownMenuItem(value: 'owner', child: Text('owners'.tr)),
                        ],
                        onChanged: controller.onRoleFilterChanged,
                        underline: const SizedBox.shrink(),
                        isExpanded: true,
                      )),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Obx(() => DropdownButton<String>(
                        value: controller.selectedSort.value,
                        items: [
                          DropdownMenuItem(value: 'name_asc', child: Text('name_az'.tr)),
                          DropdownMenuItem(value: 'name_desc', child: Text('name_za'.tr)),
                          DropdownMenuItem(value: 'newest', child: Text('newest'.tr)),
                          DropdownMenuItem(value: 'oldest', child: Text('oldest'.tr)),
                        ],
                        onChanged: controller.onSortChanged,
                        underline: const SizedBox.shrink(),
                        isExpanded: true,
                      )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(
    BuildContext context,
    String label,
    int count,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.3)
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(backgroundColor: Colors.grey[300]),
            title: Container(
              height: 16,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            subtitle: Container(
              margin: const EdgeInsets.only(top: 8),
              height: 12,
              width: 100,
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

  Widget _buildListEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No users found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(BuildContext context, AllUsersController controller) {
    return Obx(() {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.users.length + 1, // +1 for load more
        itemBuilder: (context, index) {
          if (index == controller.users.length) {
            // Load more indicator
            if (controller.pagination.value?.hasNextPage == true) {
              return Center(
                child: TextButton(
                  onPressed: controller.loadMore,
                  child: Text('load_more'.tr),
                ),
              );
            }
            return const SizedBox.shrink();
          }

          final user = controller.users[index];
          final isSelected = controller.selectedUserId.value == user.id;

          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            color: isSelected
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                : null,
            child: InkWell(
              onTap: () => controller.selectUser(user.id),
              child: ListTile(
                leading: _buildPhotoAvatar(
                  radius: 24,
                  photoUrl: user.personalPhoto.isNotEmpty ? user.personalPhoto : null,
                  iconSize: 24,
                ),
                title: Text(
                  user.fullName,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: user.role == 'tenant'
                                ? Colors.blue.withValues(alpha: 0.1)
                                : Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            user.role == 'tenant' ? 'tenant_role'.tr : 'owner_role'.tr,
                            style: TextStyle(
                              color: user.role == 'tenant' ? Colors.blue : Colors.green,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getStatusColor(user.status).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            user.status.toUpperCase(),
                            style: TextStyle(
                              color: _getStatusColor(user.status),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.mobileNumber,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      DateFormat('MMM dd, yyyy').format(user.createdAt),
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildUserDetailPanel(BuildContext context, AllUsersController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Obx(() {
        if (controller.selectedUserId.value == null) {
          return _buildNoSelectionState(context);
        }

        if (controller.isLoadingDetail.value) {
          return _buildDetailLoadingState();
        }

        final detail = controller.userDetail.value;
        if (detail == null) {
          return _buildNoSelectionState(context);
        }

        return _buildUserDetail(context, controller, detail);
      }),
    );
  }

  Widget _buildNoSelectionState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_outline, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 24),
          Text(
            'select_user_to_view_details'.tr,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'choose_user_from_list'.tr,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildUserDetail(
    BuildContext context,
    AllUsersController controller,
    UserDetail detail,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Detail Header
          _buildDetailHeader(context, detail),
          const SizedBox(height: 32),
          
          // Personal Information
          _buildSection(
            context,
            'personal_information'.tr,
            [
              _buildInfoRow(context, 'mobile_number'.tr, detail.mobileNumber),
              if (detail.dateOfBirth != null)
                _buildInfoRow(
                  context,
                  'date_of_birth'.tr,
                  '${DateFormat('MMM dd, yyyy', Get.locale?.toString() ?? 'en_US').format(detail.dateOfBirth!)} (${_calculateAge(detail.dateOfBirth!)} ${'years_old'.tr})',
                ),
              _buildInfoRow(context, 'role'.tr, detail.role == 'tenant' ? 'tenant_role'.tr : 'owner_role'.tr),
              _buildInfoRow(context, 'status'.tr, detail.status.toUpperCase()),
              _buildInfoRow(
                context,
                'registration_date'.tr,
                DateFormat('MMM dd, yyyy', Get.locale?.toString() ?? 'en_US').format(detail.createdAt),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // ID Verification
          if (detail.idPhoto != null)
            _buildSection(
              context,
              'identity_verification'.tr,
              [
                InkWell(
                  onTap: () => _showImageDialog(context, detail.idPhoto!),
                  child: Container(
                    width: 200,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        detail.idPhoto!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(child: Icon(Icons.image_not_supported));
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 24),
          
          // Account Balance
          _buildBalanceSection(context, controller, detail),
          const SizedBox(height: 24),
          
          // Activity Summary
          if (detail.activitySummary != null)
            _buildActivitySection(context, detail),
          const SizedBox(height: 24),
          
          // Account Actions
          _buildActionsSection(context, controller, detail),
        ],
      ),
    );
  }

  Widget _buildDetailHeader(BuildContext context, UserDetail detail) {
    return Column(
      children: [
        _buildPhotoAvatar(
          radius: 60,
          photoUrl: detail.personalPhoto,
          iconSize: 60,
        ),
        const SizedBox(height: 16),
        Text(
          detail.fullName,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: detail.role == 'tenant'
                    ? Colors.blue.withValues(alpha: 0.1)
                    : Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                detail.role == 'tenant' ? 'tenant_role'.tr : 'owner_role'.tr,
                style: TextStyle(
                  color: detail.role == 'tenant' ? Colors.blue : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(detail.status).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                detail.status.toUpperCase(),
                style: TextStyle(
                  color: _getStatusColor(detail.status),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${'member_since'.tr} ${DateFormat('MMM yyyy', Get.locale?.toString() ?? 'en_US').format(detail.createdAt)}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.6),
              ),
        ),
      ],
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
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
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).textTheme.bodyMedium?.color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceSection(
    BuildContext context,
    AllUsersController controller,
    UserDetail detail,
  ) {
    return _buildSection(
      context,
      'account_balance'.tr,
      [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'current_balance'.tr,
                    style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'SYP ${detail.balance.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
              Column(
                children: [
                  if (detail.role == 'tenant')
                    ElevatedButton.icon(
                      onPressed: () => _showDepositDialog(context, controller, detail),
                      icon: const Icon(Icons.add),
                      label: Text('add_money'.tr),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: () => _showWithdrawDialog(context, controller, detail),
                      icon: const Icon(Icons.remove),
                      label: Text('withdraw'.tr),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      controller.openTransactionHistoryPanel();
                    },
                    child: Text('view_transaction_history'.tr),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivitySection(BuildContext context, UserDetail detail) {
    final activity = detail.activitySummary!;
    
    return _buildSection(
      context,
      'activity_summary'.tr,
      [
        if (detail.role == 'tenant') ...[
          _buildInfoRow(context, 'total_bookings'.tr, activity.totalBookings?.toString() ?? '0'),
          _buildInfoRow(context, 'active_bookings'.tr, activity.activeBookings?.toString() ?? '0'),
          _buildInfoRow(context, 'completed_bookings'.tr, activity.completedBookings?.toString() ?? '0'),
          _buildInfoRow(context, 'reviews_given'.tr, activity.reviewsGiven?.toString() ?? '0'),
        ] else ...[
          _buildInfoRow(context, 'total_apartments'.tr, activity.totalApartments?.toString() ?? '0'),
          _buildInfoRow(context, 'active_apartments'.tr, activity.activeApartments?.toString() ?? '0'),
          _buildInfoRow(context, 'total_bookings_received'.tr, activity.totalBookingsReceived?.toString() ?? '0'),
          if (activity.averageRating != null)
            _buildInfoRow(
              context,
              'average_rating'.tr,
              '⭐ ${activity.averageRating!.toStringAsFixed(1)}',
            ),
        ],
      ],
    );
  }

  Widget _buildActionsSection(
    BuildContext context,
    AllUsersController controller,
    UserDetail detail,
  ) {
    return _buildSection(
      context,
      'account_actions'.tr,
      [
        if (!detail.canDelete) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning, color: Colors.orange),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'user_has_active_bookings'.tr.replaceAll('{count}', detail.activeBookingsCount.toString()),
                    style: const TextStyle(color: Colors.orange),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        Row(
          children: [
            OutlinedButton(
              onPressed: () {
                Get.to(() => UserFullProfilePage(userDetail: detail));
              },
              child: Text('view_full_profile'.tr),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () {
                Get.dialog(
                  SendMessageDialog(
                    recipientId: detail.id,
                    recipientName: detail.fullName,
                  ),
                );
              },
              child: Text('send_message'.tr),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: detail.canDelete
                  ? () => _showDeleteDialog(context, controller, detail)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text('delete_user'.tr),
            ),
          ],
        ),
      ],
    );
  }

  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: InteractiveViewer(
          child: Image.network(imageUrl),
        ),
      ),
    );
  }

  void _showDepositDialog(
    BuildContext context,
    AllUsersController controller,
    UserDetail detail,
  ) {
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('add_money'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${'user_label'.tr}: ${detail.fullName}'),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'amount_syp'.tr,
                border: const OutlineInputBorder(),
                prefixText: 'SYP ',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'description'.tr,
                hintText: 'enter_description'.tr,
                border: const OutlineInputBorder(),
              ),
              maxLines: 2,
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
              final amount = double.tryParse(amountController.text);
              if (amount != null && amount > 0) {
                Get.back();
                controller.depositMoney(
                  detail.id,
                  amount,
                  description: descriptionController.text.trim().isEmpty
                      ? null
                      : descriptionController.text.trim(),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text('add_money'.tr),
          ),
        ],
      ),
    );
  }

  void _showWithdrawDialog(
    BuildContext context,
    AllUsersController controller,
    UserDetail detail,
  ) {
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('withdraw_money'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${'user_label'.tr}: ${detail.fullName}'),
            Text('${'current_balance'.tr}: SYP ${detail.balance.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'amount_syp'.tr,
                border: const OutlineInputBorder(),
                prefixText: 'SYP ',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'description'.tr,
                hintText: 'enter_description'.tr,
                border: const OutlineInputBorder(),
              ),
              maxLines: 2,
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
              final amount = double.tryParse(amountController.text);
              if (amount != null && amount > 0 && amount <= detail.balance) {
                Get.back();
                controller.withdrawMoney(
                  detail.id,
                  amount,
                  description: descriptionController.text.trim().isEmpty
                      ? null
                      : descriptionController.text.trim(),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: Text('withdraw'.tr),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    AllUsersController controller,
    UserDetail detail,
  ) {
    final confirmController = TextEditingController();
    final canDelete = false.obs;
    
    confirmController.addListener(() {
      canDelete.value = confirmController.text == 'DELETE';
    });
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('delete_user_account'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: detail.personalPhoto != null && detail.personalPhoto!.isNotEmpty
                      ? NetworkImage(detail.personalPhoto!)
                      : null,
                  child: detail.personalPhoto == null || detail.personalPhoto!.isEmpty
                      ? const Icon(Icons.person)
                      : null,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(detail.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(detail.role == 'tenant' ? 'tenant_role'.tr : 'owner_role'.tr),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'this_action_cannot_be_undone'.tr,
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('all_user_data_deleted'.tr),
            const SizedBox(height: 16),
            TextField(
              controller: confirmController,
              decoration: InputDecoration(
                labelText: 'type_delete_to_confirm'.tr,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          Obx(() => ElevatedButton(
                onPressed: canDelete.value
                    ? () {
                        Get.back();
                        controller.deleteUser(detail.id);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: Text('delete_permanently'.tr),
              )),
        ],
      ),
    );
  }

  Widget _buildPhotoAvatar({
    required double radius,
    required String? photoUrl,
    required double iconSize,
  }) {
    if (photoUrl == null || photoUrl.isEmpty) {
      return CircleAvatar(
        radius: radius,
        child: Icon(Icons.person, size: iconSize),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundImage: NetworkImage(photoUrl),
      onBackgroundImageError: (exception, stackTrace) {
        debugPrint('Failed to load user photo: $photoUrl - $exception');
      },
      child: photoUrl.isEmpty
          ? Icon(Icons.person, size: iconSize)
          : null,
    );
  }
}
