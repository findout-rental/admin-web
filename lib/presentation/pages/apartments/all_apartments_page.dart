import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../domain/usecases/apartment/get_all_apartments_usecase.dart';
import '../../../domain/usecases/apartment/get_apartment_detail_usecase.dart';
import '../../../domain/usecases/location/get_governorates_usecase.dart';
import '../../../domain/usecases/location/get_cities_by_governorate_usecase.dart';
import '../../controllers/apartment/all_apartments_controller.dart';
import '../../widgets/layout/app_scaffold.dart';
import '../../widgets/layout/breadcrumb.dart';

class AllApartmentsPage extends StatelessWidget {
  const AllApartmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'all_apartments'.tr,
      currentRoute: '/apartments',
      breadcrumbs: [
        BreadcrumbItem(label: 'dashboard'.tr, route: '/dashboard'),
        BreadcrumbItem(label: 'all_apartments'.tr, route: '/apartments'),
      ],
      child: GetBuilder<AllApartmentsController>(
        init: AllApartmentsController(
          getAllApartmentsUsecase: Get.find<GetAllApartmentsUsecase>(),
          getApartmentDetailUsecase: Get.find<GetApartmentDetailUsecase>(),
          getGovernoratesUsecase: Get.find<GetGovernoratesUsecase>(),
          getCitiesByGovernorateUsecase: Get.find<GetCitiesByGovernorateUsecase>(),
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
                child: Row(
                  children: [
                    // Table Area
                    Expanded(
                      child: Obx(() {
                        if (controller.isLoading.value &&
                            controller.apartments.isEmpty) {
                          return _buildLoadingState();
                        }

                        if (controller.apartments.isEmpty) {
                          return _buildEmptyState(context);
                        }

                        return _buildDataTable(context, controller);
                      }),
                    ),

                    // Detail Panel (Slide-out)
                    Obx(() {
                      if (controller.selectedApartmentId.value == null) {
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

  Widget _buildPageHeader(
      BuildContext context, AllApartmentsController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
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
                'all_apartments'.tr,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Obx(() {
                final total = controller.apartments.length;
                final active =
                    controller.apartments.where((a) => a.status == 'active').length;
                final inactive = controller.apartments
                    .where((a) => a.status == 'inactive')
                    .length;
                return Text(
                  '${'total_apartments_count'.tr}: $total ${'apartments'.tr.toLowerCase()} ($active ${'active'.tr}, $inactive ${'inactive'.tr})',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar(
      BuildContext context, AllApartmentsController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Column(
        children: [
          // Search Bar
          TextField(
            onChanged: controller.onSearchChanged,
            decoration: InputDecoration(
              hintText: 'search_by_address_or_owner'.tr,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 12),

          // Filters Row
          Row(
            children: [
              // Status Filter
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Obx(() => DropdownButton<String>(
                        value: controller.selectedStatus.value,
                        items: [
                          DropdownMenuItem(
                              value: 'all', child: Text('all_status'.tr)),
                          DropdownMenuItem(
                              value: 'active', child: Text('active'.tr)),
                          DropdownMenuItem(
                              value: 'inactive', child: Text('inactive'.tr)),
                        ],
                        onChanged: controller.onStatusFilterChanged,
                        underline: const SizedBox.shrink(),
                        isExpanded: true,
                      )),
                ),
              ),
              const SizedBox(width: 8),

              // Governorate Filter
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).inputDecorationTheme.fillColor ?? Theme.of(context).cardColor,
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Obx(() {
                    if (controller.isLoadingGovernorates.value) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }
                    
                    return DropdownButton<String>(
                      value: controller.selectedGovernorate.value.isEmpty
                          ? null
                          : controller.selectedGovernorate.value,
                      hint: Text('all_governorates'.tr),
                      items: [
                        DropdownMenuItem<String>(
                          value: '',
                          child: Text('all_governorates'.tr),
                        ),
                        ...controller.governorates.map((gov) {
                          return DropdownMenuItem<String>(
                            value: gov.name,
                            child: Text(gov.name),
                          );
                        }),
                      ],
                      onChanged: controller.onGovernorateChanged,
                      underline: const SizedBox.shrink(),
                        icon: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).iconTheme.color?.withValues(alpha: 0.6)),
                      isExpanded: true,
                    );
                  }),
                ),
              ),
              const SizedBox(width: 8),

              // City Filter
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).inputDecorationTheme.fillColor ?? Theme.of(context).cardColor,
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Obx(() {
                    if (controller.selectedGovernorate.value.isEmpty) {
                      return DropdownButton<String>(
                        value: null,
                        hint: Text('select_governorate_first'.tr),
                        items: const [],
                        onChanged: null,
                        underline: const SizedBox.shrink(),
                        icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[400]),
                        isExpanded: true,
                      );
                    }
                    
                    if (controller.isLoadingCities.value) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }
                    
                    return DropdownButton<String>(
                      value: controller.selectedCity.value.isEmpty
                          ? null
                          : controller.selectedCity.value,
                      hint: Text('all_cities'.tr),
                      items: [
                        DropdownMenuItem<String>(
                          value: '',
                          child: Text('all_cities'.tr),
                        ),
                        ...controller.cities.map((city) {
                          return DropdownMenuItem<String>(
                            value: city.name,
                            child: Text(city.name),
                          );
                        }),
                      ],
                      onChanged: controller.onCityChanged,
                      underline: const SizedBox.shrink(),
                        icon: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).iconTheme.color?.withValues(alpha: 0.6)),
                      isExpanded: true,
                    );
                  }),
                ),
              ),
              const SizedBox(width: 8),

              // Sort Dropdown
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
                          DropdownMenuItem(
                              value: 'newest', child: Text('newest'.tr)),
                          DropdownMenuItem(
                              value: 'oldest', child: Text('oldest'.tr)),
                          DropdownMenuItem(
                              value: 'price_low',
                              child: Text('price_low_to_high'.tr)),
                          DropdownMenuItem(
                              value: 'price_high',
                              child: Text('price_high_to_low'.tr)),
                          DropdownMenuItem(
                              value: 'rating', child: Text('rating'.tr)),
                        ],
                        onChanged: controller.onSortChanged,
                        underline: const SizedBox.shrink(),
                        isExpanded: true,
                      )),
                ),
              ),
              const SizedBox(width: 8),

              // Refresh Button
              Obx(() => IconButton(
                    icon: controller.isLoading.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.refresh),
                    onPressed:
                        controller.isLoading.value ? null : controller.refresh,
                    tooltip: 'refresh'.tr,
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
            leading: Container(
              width: 60,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.apartment_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 24),
          Text(
            'no_apartments'.tr,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'apartments_will_appear'.tr,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(
      BuildContext context, AllApartmentsController controller) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              child: Obx(() {
                return DataTable(
                  columns: [
                    DataColumn(label: Text('photo'.tr)),
                    DataColumn(label: Text('address'.tr)),
                    DataColumn(label: Text('owner'.tr)),
                    DataColumn(label: Text('location'.tr)),
                    DataColumn(label: Text('price'.tr)),
                    DataColumn(label: Text('status'.tr)),
                    DataColumn(label: Text('rating'.tr)),
                    DataColumn(label: Text('bookings'.tr)),
                    DataColumn(label: Text('created'.tr)),
                    DataColumn(label: Text('actions'.tr)),
                  ],
                  rows: controller.apartments.map((apartment) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Container(
                            width: 60,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              image: apartment.mainPhoto != null
                                  ? DecorationImage(
                                      image: NetworkImage(apartment.mainPhoto!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                              color: apartment.mainPhoto == null
                                  ? Colors.grey[300]
                                  : null,
                            ),
                            child: apartment.mainPhoto == null
                                ? const Icon(Icons.image, size: 20)
                                : null,
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: 200,
                            child: Text(
                              apartment.address,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(
                          InkWell(
                            onTap: () => Get.toNamed('/users'),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundImage: apartment.ownerPhoto != null
                                      ? NetworkImage(apartment.ownerPhoto!)
                                      : null,
                                  child: apartment.ownerPhoto == null
                                      ? const Icon(Icons.person, size: 16)
                                      : null,
                                ),
                                const SizedBox(width: 8),
                                Text(apartment.ownerName),
                              ],
                            ),
                          ),
                        ),
                        DataCell(Text(apartment.location)),
                        DataCell(
                          apartment.price != null
                              ? Text(
                                  'SYP ${apartment.price!.toStringAsFixed(0)}/${apartment.pricePeriod ?? 'period'}',
                                )
                              : const Text('N/A'),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: apartment.status == 'active'
                                  ? Colors.green.withValues(alpha: 0.1)
                                  : Colors.grey.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              apartment.status.toUpperCase(),
                              style: TextStyle(
                                color: apartment.status == 'active'
                                    ? Colors.green
                                    : Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          apartment.averageRating != null
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.star,
                                        size: 16, color: Colors.amber),
                                    Text(
                                      ' ${apartment.averageRating!.toStringAsFixed(1)}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    if (apartment.totalRatings != null)
                                      Text(
                                        ' (${apartment.totalRatings})',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                  ],
                                )
                              : const Text('N/A'),
                        ),
                        DataCell(Text(apartment.totalBookings.toString())),
                        DataCell(
                          Text(
                            DateFormat('MMM dd, yyyy')
                                .format(apartment.createdAt),
                          ),
                        ),
                        DataCell(
                          TextButton(
                            onPressed: () =>
                                controller.viewApartmentDetail(apartment.id),
                            child: Text('view_details'.tr),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                );
              }),
            ),
          ),
        ),

        // Pagination
        Obx(() => _buildPagination(context, controller)),
      ],
    );
  }

  Widget _buildPagination(
      BuildContext context, AllApartmentsController controller) {
    final pagination = controller.pagination.value;
    if (pagination == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            () {
              final apartmentsCount = controller.apartments.length;
              final start = pagination.totalItems == 0
                  ? 0
                  : ((pagination.currentPage - 1) * pagination.perPage) + 1;
              final end = pagination.totalItems == 0
                  ? 0
                  : ((pagination.currentPage - 1) * pagination.perPage + apartmentsCount).clamp(0, pagination.totalItems);
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

  Widget _buildDetailPanel(
      BuildContext context, AllApartmentsController controller) {
    return Container(
      width: 400,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          left: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Obx(() {
        if (controller.isLoadingDetail.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final detail = controller.apartmentDetail.value;
        if (detail == null) {
          return Center(child: Text('no_details_available'.tr));
        }

        return Column(
          children: [
            // Panel Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'apartment_details'.tr,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: controller.closeDetail,
                  ),
                ],
              ),
            ),

            // Panel Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _buildDetailContent(context, detail),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildDetailContent(
      BuildContext context, Map<String, dynamic> detail) {
    final apartment =
        detail['data']?['apartment'] as Map<String, dynamic>? ?? detail;
    final owner = apartment['owner'] as Map<String, dynamic>? ?? {};
    final photos = apartment['photos'] as List<dynamic>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Photo Gallery
        if (photos.isNotEmpty)
          SizedBox(
            height: 200,
            child: PageView.builder(
              itemCount: photos.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(photos[index] as String),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),

        const SizedBox(height: 16),

        // Address
        Text(
          apartment['address'] as String? ?? 'N/A',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),

        // Owner Info
        InkWell(
          onTap: () {
            final ownerId = owner['id'] as int?;
            if (ownerId != null) {
              Get.toNamed('/users');
            }
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: owner['personal_photo'] != null
                    ? NetworkImage(owner['personal_photo'] as String)
                    : null,
                child: owner['personal_photo'] == null
                    ? const Icon(Icons.person)
                    : null,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    owner['name'] as String? ?? 'N/A',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'owner'.tr,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Price and Specifications
        if (apartment['price'] != null) ...[
          Text(
            'SYP ${apartment['price']}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 8),
        ],

        // Description
        if (apartment['description'] != null) ...[
          Text(
            'Description',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(apartment['description'] as String),
          const SizedBox(height: 16),
        ],

        // Statistics
        Text(
          'Statistics',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        _buildInfoRow(
            'Total Bookings', apartment['total_bookings']?.toString() ?? '0'),
        if (apartment['average_rating'] != null)
          _buildInfoRow(
            'average_rating'.tr,
            '⭐ ${(apartment['average_rating'] as num).toStringAsFixed(1)}',
          ),
        _buildInfoRow(
          'Created Date',
          apartment['created_at'] != null
              ? DateFormat('MMM dd, yyyy').format(
                  DateTime.parse(apartment['created_at'] as String),
                )
              : 'N/A',
        ),

        const SizedBox(height: 16),

        // View Owner Profile Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              final ownerId = owner['id'] as int?;
              if (ownerId != null) {
                Get.toNamed('/users');
              }
            },
            child: Text('view_owner_profile'.tr),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
