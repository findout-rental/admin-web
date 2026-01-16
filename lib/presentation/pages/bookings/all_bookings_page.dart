import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/booking.dart';
import '../../../domain/usecases/booking/get_all_bookings_usecase.dart';
import '../../../domain/usecases/booking/get_booking_detail_usecase.dart';
import '../../controllers/booking/all_bookings_controller.dart';
import '../../widgets/layout/app_scaffold.dart';
import '../../widgets/layout/breadcrumb.dart';

class AllBookingsPage extends StatelessWidget {
  const AllBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'all_bookings'.tr,
      currentRoute: '/bookings',
      breadcrumbs: [
        BreadcrumbItem(label: 'dashboard'.tr, route: '/dashboard'),
        BreadcrumbItem(label: 'all_bookings'.tr, route: '/bookings'),
      ],
      child: GetBuilder<AllBookingsController>(
        init: AllBookingsController(
          getAllBookingsUsecase: Get.find<GetAllBookingsUsecase>(),
          getBookingDetailUsecase: Get.find<GetBookingDetailUsecase>(),
        ),
        builder: (controller) {
          return Column(
            children: [
              // Minimal Header
              _buildPageHeader(context, controller),
              
              // Toolbar
              _buildToolbar(context, controller),
              
              // Data Table
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Obx(() {
                        if (controller.isLoading.value && controller.bookings.isEmpty) {
                          return _buildLoadingState();
                        }
                        if (controller.bookings.isEmpty) {
                          return _buildEmptyState(context);
                        }
                        return _buildDataTable(context, controller);
                      }),
                    ),
                    Obx(() {
                      if (controller.selectedBookingId.value == null) {
                        return const SizedBox.shrink();
                      }
                      return _buildDetailPanel(context, controller);
                    }),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPageHeader(BuildContext context, AllBookingsController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'all_bookings'.tr,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                    ),
              ),
              const SizedBox(height: 6),
              Obx(() {
                final total = controller.bookings.length;
                final active = controller.bookings.where((b) => b.status == 'active').length;
                final completed = controller.bookings.where((b) => b.status == 'completed').length;
                return Text(
                  '$total total • $active active • $completed completed',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context, AllBookingsController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Column(
        children: [
          // Search Bar
          TextField(
            onChanged: controller.onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search bookings...',
              prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 12),
          
          // Filters Row
          Row(
            children: [
              // Status Filter Tabs
              Expanded(
                child: Obx(() {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildStatusChip(context, 'All', controller.selectedStatus.value == 'all',
                            () => controller.onStatusFilterChanged('all')),
                        const SizedBox(width: 6),
                        _buildStatusChip(context, 'Pending', controller.selectedStatus.value == 'pending',
                            () => controller.onStatusFilterChanged('pending')),
                        const SizedBox(width: 6),
                        _buildStatusChip(context, 'Approved', controller.selectedStatus.value == 'approved',
                            () => controller.onStatusFilterChanged('approved')),
                        const SizedBox(width: 6),
                        _buildStatusChip(context, 'Active', controller.selectedStatus.value == 'active',
                            () => controller.onStatusFilterChanged('active')),
                        const SizedBox(width: 6),
                        _buildStatusChip(context, 'Completed', controller.selectedStatus.value == 'completed',
                            () => controller.onStatusFilterChanged('completed')),
                        const SizedBox(width: 6),
                        _buildStatusChip(context, 'Cancelled', controller.selectedStatus.value == 'cancelled',
                            () => controller.onStatusFilterChanged('cancelled')),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(width: 12),
              
              // Sort Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Obx(() => DropdownButton<String>(
                      value: controller.selectedSort.value,
                      items: [
                        DropdownMenuItem(value: 'newest', child: Text('newest'.tr)),
                        DropdownMenuItem(value: 'oldest', child: Text('oldest'.tr)),
                        DropdownMenuItem(value: 'check_in', child: Text('check_in'.tr)),
                        DropdownMenuItem(value: 'check_out', child: Text('check_out'.tr)),
                      ],
                      onChanged: controller.onSortChanged,
                      underline: const SizedBox.shrink(),
                      icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
                      style: Theme.of(context).textTheme.bodyMedium,
                    )),
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
                    onPressed: controller.isLoading.value ? null : controller.refresh,
                    tooltip: 'Refresh',
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

  Widget _buildStatusChip(BuildContext context, String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ListView.builder(
        itemCount: 8,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
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
                Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 12, width: 150, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(4))),
                      const SizedBox(height: 8),
                      Container(height: 10, width: 100, decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4))),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 24),
          Text(
            'No bookings found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Bookings will appear here as users make reservations',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(BuildContext context, AllBookingsController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.separated(
                itemCount: controller.bookings.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final booking = controller.bookings[index];
                  return _buildBookingCard(context, controller, booking);
                },
              );
            }),
          ),
          Obx(() => _buildPagination(context, controller)),
        ],
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, AllBookingsController controller, Booking booking) {
    return InkWell(
      onTap: () => controller.viewBookingDetail(booking.id),
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
            // Booking ID
            SizedBox(
              width: 60,
              child: Text(
                '#${booking.id}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.grey[800],
                ),
              ),
            ),
            
            // Tenant
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: booking.tenantPhoto != null
                        ? NetworkImage(booking.tenantPhoto!)
                        : null,
                    child: booking.tenantPhoto == null
                        ? Icon(Icons.person, size: 18, color: Colors.grey[600])
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      booking.tenantName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            
            // Apartment
            Expanded(
              flex: 2,
              child: Text(
                booking.apartmentAddress,
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            // Owner
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: booking.ownerPhoto != null
                        ? NetworkImage(booking.ownerPhoto!)
                        : null,
                    child: booking.ownerPhoto == null
                        ? Icon(Icons.person, size: 16, color: Colors.grey[600])
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      booking.ownerName,
                      style: const TextStyle(fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            
            // Dates
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('MMM dd').format(booking.checkInDate),
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    DateFormat('MMM dd').format(booking.checkOutDate),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            
            // Duration
            Expanded(
              child: Text(
                '${booking.duration} ${booking.duration == 1 ? 'night' : 'nights'}',
                style: const TextStyle(fontSize: 13),
              ),
            ),
            
            // Price
            Expanded(
              child: Text(
                'EGP ${booking.totalPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            
            // Status
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(booking.status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  booking.status.toUpperCase(),
                  style: TextStyle(
                    color: _getStatusColor(booking.status),
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            
            // Actions
            IconButton(
              icon: Icon(Icons.chevron_right, color: Colors.grey[400]),
              onPressed: () => controller.viewBookingDetail(booking.id),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.blue;
      case 'active':
        return Colors.green;
      case 'completed':
        return Colors.grey;
      case 'cancelled':
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildPagination(BuildContext context, AllBookingsController controller) {
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
            '${'showing'.tr} ${((pagination.currentPage - 1) * pagination.perPage) + 1}-${(pagination.currentPage * pagination.perPage).clamp(0, pagination.totalItems)} ${'of'.tr} ${pagination.totalItems}',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.first_page, size: 20),
                onPressed: pagination.hasPreviousPage ? () => controller.goToPage(1) : null,
                style: IconButton.styleFrom(padding: const EdgeInsets.all(8)),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_left, size: 20),
                onPressed: pagination.hasPreviousPage ? () => controller.goToPage(pagination.currentPage - 1) : null,
                style: IconButton.styleFrom(padding: const EdgeInsets.all(8)),
              ),
              ...List.generate(
                pagination.totalPages.clamp(0, 5),
                (index) {
                  final page = index + 1;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: TextButton(
                      onPressed: () => controller.goToPage(page),
                      style: TextButton.styleFrom(
                        backgroundColor: page == pagination.currentPage ? Theme.of(context).colorScheme.primary : null,
                        foregroundColor: page == pagination.currentPage ? Colors.white : Colors.grey[700],
                        minimumSize: const Size(32, 32),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text('$page', style: const TextStyle(fontSize: 13)),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, size: 20),
                onPressed: pagination.hasNextPage ? () => controller.goToPage(pagination.currentPage + 1) : null,
                style: IconButton.styleFrom(padding: const EdgeInsets.all(8)),
              ),
              IconButton(
                icon: const Icon(Icons.last_page, size: 20),
                onPressed: pagination.hasNextPage ? () => controller.goToPage(pagination.totalPages) : null,
                style: IconButton.styleFrom(padding: const EdgeInsets.all(8)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailPanel(BuildContext context, AllBookingsController controller) {
    return Container(
      width: 400,
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Obx(() {
        if (controller.isLoadingDetail.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final detail = controller.bookingDetail.value;
        if (detail == null) {
          return Center(child: Text('no_details_available'.tr));
        }
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Booking Details',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: controller.closeDetail,
                    style: IconButton.styleFrom(padding: const EdgeInsets.all(8)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _buildDetailContent(context, detail),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildDetailContent(BuildContext context, Map<String, dynamic> detail) {
    final booking = detail['data']?['booking'] as Map<String, dynamic>? ?? detail;
    final tenant = booking['tenant'] as Map<String, dynamic>? ?? {};
    final apartment = booking['apartment'] as Map<String, dynamic>? ?? {};
    final owner = apartment['owner'] as Map<String, dynamic>? ?? booking['owner'] as Map<String, dynamic>? ?? {};
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Booking #${booking['id']}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 24),
        
        _buildDetailSection(
          context,
          'Tenant',
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: tenant['personal_photo'] != null
                    ? NetworkImage(tenant['personal_photo'] as String)
                    : null,
                child: tenant['personal_photo'] == null ? const Icon(Icons.person) : null,
              ),
              const SizedBox(width: 12),
              Text(tenant['name'] as String? ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        
        _buildDetailSection(
          context,
          'Apartment',
          Text(apartment['address'] as String? ?? 'N/A'),
        ),
        
        _buildDetailSection(
          context,
          'Owner',
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: owner['personal_photo'] != null
                    ? NetworkImage(owner['personal_photo'] as String)
                    : null,
                child: owner['personal_photo'] == null ? const Icon(Icons.person) : null,
              ),
              const SizedBox(width: 12),
              Text(owner['name'] as String? ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        
        _buildDetailSection(
          context,
          'Booking Period',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Check-in', booking['check_in_date'] != null
                  ? DateFormat('MMM dd, yyyy').format(DateTime.parse(booking['check_in_date'] as String))
                  : 'N/A'),
              const SizedBox(height: 8),
              _buildDetailRow('Check-out', booking['check_out_date'] != null
                  ? DateFormat('MMM dd, yyyy').format(DateTime.parse(booking['check_out_date'] as String))
                  : 'N/A'),
              const SizedBox(height: 8),
              _buildDetailRow('Duration', booking['duration'] != null
                  ? '${booking['duration']} ${booking['duration'] == 1 ? 'night' : 'nights'}'
                  : 'N/A'),
            ],
          ),
        ),
        
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('total_price'.tr, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(
                'EGP ${booking['total_price'] != null ? (booking['total_price'] as num).toStringAsFixed(2) : '0.00'}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailSection(BuildContext context, String title, Widget content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
          ),
          const SizedBox(height: 8),
          content,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
      ],
    );
  }
}
