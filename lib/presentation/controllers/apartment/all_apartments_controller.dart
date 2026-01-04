import 'package:get/get.dart';
import '../../../domain/entities/apartment.dart';
import '../../../domain/entities/pagination.dart';
import '../../../domain/usecases/apartment/get_all_apartments_usecase.dart';
import '../../../domain/usecases/apartment/get_apartment_detail_usecase.dart';

class AllApartmentsController extends GetxController {
  final GetAllApartmentsUsecase getAllApartmentsUsecase;
  final GetApartmentDetailUsecase getApartmentDetailUsecase;

  AllApartmentsController({
    required this.getAllApartmentsUsecase,
    required this.getApartmentDetailUsecase,
  });

  // State
  final isLoading = false.obs;
  final apartments = <Apartment>[].obs;
  final pagination = Rxn<Pagination>();

  // Filters
  final searchQuery = ''.obs;
  final selectedStatus = 'all'.obs; // 'all', 'active', 'inactive'
  final selectedGovernorate = ''.obs;
  final selectedCity = ''.obs;
  final selectedSort = 'newest'.obs;
  final currentPage = 1.obs;
  final perPage = 25;

  // Detail
  final selectedApartmentId = Rxn<int>();
  final isLoadingDetail = false.obs;
  final apartmentDetail = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    loadApartments();
  }

  Future<void> loadApartments({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;

    try {
      final result = await getAllApartmentsUsecase.execute(
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
        status: selectedStatus.value == 'all' ? null : selectedStatus.value,
        governorate: selectedGovernorate.value.isEmpty
            ? null
            : selectedGovernorate.value,
        city: selectedCity.value.isEmpty ? null : selectedCity.value,
        sort: selectedSort.value,
        page: currentPage.value,
        perPage: perPage,
      );

      apartments.value = result.apartments;
      pagination.value = result.pagination;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to load apartments. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  Future<void> loadApartmentDetail(int apartmentId) async {
    selectedApartmentId.value = apartmentId;
    isLoadingDetail.value = true;

    try {
      final detail = await getApartmentDetailUsecase.execute(apartmentId);
      apartmentDetail.value = detail;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to load apartment details.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingDetail.value = false;
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    currentPage.value = 1;
    loadApartments();
  }

  void onStatusFilterChanged(String? status) {
    if (status != null) {
      selectedStatus.value = status;
      currentPage.value = 1;
      loadApartments();
    }
  }

  void onGovernorateChanged(String? governorate) {
    selectedGovernorate.value = governorate ?? '';
    selectedCity.value = ''; // Reset city when governorate changes
    currentPage.value = 1;
    loadApartments();
  }

  void onCityChanged(String? city) {
    if (city != null) {
      selectedCity.value = city;
      currentPage.value = 1;
      loadApartments();
    }
  }

  void onSortChanged(String? sort) {
    if (sort != null) {
      selectedSort.value = sort;
      currentPage.value = 1;
      loadApartments();
    }
  }

  void goToPage(int page) {
    currentPage.value = page;
    loadApartments();
  }

  @override
  void refresh() {
    loadApartments();
    if (selectedApartmentId.value != null) {
      loadApartmentDetail(selectedApartmentId.value!);
    }
  }

  void viewApartmentDetail(int apartmentId) {
    loadApartmentDetail(apartmentId);
  }

  void closeDetail() {
    selectedApartmentId.value = null;
    apartmentDetail.value = null;
  }
}
