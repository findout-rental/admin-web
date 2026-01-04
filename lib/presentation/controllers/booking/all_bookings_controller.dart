import 'package:get/get.dart';
import '../../../domain/entities/booking.dart';
import '../../../domain/entities/pagination.dart';
import '../../../domain/usecases/booking/get_all_bookings_usecase.dart';
import '../../../domain/usecases/booking/get_booking_detail_usecase.dart';

class AllBookingsController extends GetxController {
  final GetAllBookingsUsecase getAllBookingsUsecase;
  final GetBookingDetailUsecase getBookingDetailUsecase;

  AllBookingsController({
    required this.getAllBookingsUsecase,
    required this.getBookingDetailUsecase,
  });

  // State
  final isLoading = false.obs;
  final bookings = <Booking>[].obs;
  final pagination = Rxn<Pagination>();

  // Filters
  final searchQuery = ''.obs;
  final selectedStatus = 'all'.obs; // 'all', 'pending', 'approved', 'active', 'completed', 'cancelled'
  final checkInFrom = Rxn<DateTime>();
  final checkInTo = Rxn<DateTime>();
  final selectedSort = 'newest'.obs;
  final currentPage = 1.obs;
  final perPage = 25;

  // Detail
  final selectedBookingId = Rxn<int>();
  final isLoadingDetail = false.obs;
  final bookingDetail = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    loadBookings();
  }

  Future<void> loadBookings({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;

    try {
      final result = await getAllBookingsUsecase.execute(
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
        status: selectedStatus.value == 'all' ? null : selectedStatus.value,
        checkInFrom: checkInFrom.value,
        checkInTo: checkInTo.value,
        sort: selectedSort.value,
        page: currentPage.value,
        perPage: perPage,
      );

      bookings.value = result.bookings;
      pagination.value = result.pagination;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to load bookings. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  Future<void> loadBookingDetail(int bookingId) async {
    selectedBookingId.value = bookingId;
    isLoadingDetail.value = true;

    try {
      final detail = await getBookingDetailUsecase.execute(bookingId);
      bookingDetail.value = detail;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to load booking details.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingDetail.value = false;
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    currentPage.value = 1;
    loadBookings();
  }

  void onStatusFilterChanged(String? status) {
    if (status != null) {
      selectedStatus.value = status;
      currentPage.value = 1;
      loadBookings();
    }
  }

  void onDateRangeChanged(DateTime? from, DateTime? to) {
    checkInFrom.value = from;
    checkInTo.value = to;
    currentPage.value = 1;
    loadBookings();
  }

  void onSortChanged(String? sort) {
    if (sort != null) {
      selectedSort.value = sort;
      currentPage.value = 1;
      loadBookings();
    }
  }

  void goToPage(int page) {
    currentPage.value = page;
    loadBookings();
  }

  @override
  void refresh() {
    loadBookings();
    if (selectedBookingId.value != null) {
      loadBookingDetail(selectedBookingId.value!);
    }
  }

  void viewBookingDetail(int bookingId) {
    loadBookingDetail(bookingId);
  }

  void closeDetail() {
    selectedBookingId.value = null;
    bookingDetail.value = null;
  }
}

