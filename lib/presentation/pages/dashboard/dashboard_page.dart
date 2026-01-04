import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../domain/usecases/dashboard/get_statistics_usecase.dart';
import '../../controllers/dashboard/dashboard_controller.dart';
import '../../widgets/layout/app_scaffold.dart';
import '../../widgets/cards/stat_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Dashboard',
      currentRoute: '/dashboard',
      child: GetBuilder<DashboardController>(
        init: DashboardController(Get.find<GetStatisticsUsecase>()),
        builder: (controller) {
          return RefreshIndicator(
            onRefresh: controller.loadStatistics,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Page Header
                  _buildPageHeader(context, controller),
                  const SizedBox(height: 32),
                  
                  // Statistics Cards Grid
                  Obx(() {
                    if (controller.isLoading.value) {
                      return _buildLoadingState();
                    }
                    return _buildStatisticsGrid(context, controller);
                  }),
                  
                  const SizedBox(height: 32),
                  
                  // Quick Actions
                  _buildQuickActions(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPageHeader(BuildContext context, DashboardController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dashboard',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Overview of your platform',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        Obx(() {
          if (controller.statistics.value != null) {
            final lastUpdated = controller.statistics.value!.lastUpdated;
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Last updated: ${DateFormat('MMM dd, yyyy - HH:mm').format(lastUpdated)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                    ),
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildLoadingState() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: List.generate(4, (index) {
        return Card(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 120,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStatisticsGrid(BuildContext context, DashboardController controller) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        // Total Users Card
        StatCard(
          icon: Icons.people,
          title: 'Total Users',
          value: _formatNumber(controller.totalUsers.value),
          subtitle: '${_formatNumber(controller.totalTenants.value)} Tenants | ${_formatNumber(controller.totalOwners.value)} Owners',
          iconColor: Colors.blue,
          onTap: () => Get.toNamed('/users'),
        ),
        
        // Total Apartments Card
        StatCard(
          icon: Icons.apartment,
          title: 'Total Apartments',
          value: _formatNumber(controller.totalApartments.value),
          subtitle: '${_formatNumber(controller.activeApartments.value)} Active | ${_formatNumber(controller.inactiveApartments.value)} Inactive',
          iconColor: Colors.green,
          onTap: () => Get.toNamed('/apartments'),
        ),
        
        // Pending Registrations Card
        StatCard(
          icon: Icons.pending_actions,
          title: 'Pending Registrations',
          value: _formatNumber(controller.pendingRegistrations.value),
          iconColor: Colors.orange,
          action: controller.pendingRegistrations.value > 0
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Action Required',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : null,
          onTap: () => Get.toNamed('/pending-registrations'),
        ),
        
        // Total Bookings Card
        StatCard(
          icon: Icons.calendar_today,
          title: 'Total Bookings',
          value: _formatNumber(controller.totalBookings.value),
          subtitle: '${_formatNumber(controller.activeBookings.value)} Active | ${_formatNumber(controller.completedBookings.value)} Completed',
          iconColor: Colors.purple,
          onTap: () => Get.toNamed('/bookings'),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildQuickActionButton(
              context,
              'Review Pending Registrations',
              Icons.pending_actions,
              Colors.orange,
              () => Get.toNamed('/pending-registrations'),
            ),
            _buildQuickActionButton(
              context,
              'View All Users',
              Icons.people,
              Colors.blue,
              () => Get.toNamed('/users'),
            ),
            _buildQuickActionButton(
              context,
              'View All Apartments',
              Icons.apartment,
              Colors.green,
              () => Get.toNamed('/apartments'),
            ),
            _buildQuickActionButton(
              context,
              'View All Bookings',
              Icons.calendar_today,
              Colors.purple,
              () => Get.toNamed('/bookings'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
