import 'package:get/get.dart';
import '../../../domain/entities/pending_registration.dart';
import '../../../domain/entities/pagination.dart';
import '../../../domain/usecases/registration/get_pending_registrations_usecase.dart';
import '../../../domain/usecases/registration/approve_registration_usecase.dart';
import '../../../domain/usecases/registration/reject_registration_usecase.dart';

class PendingRegistrationsController extends GetxController {
  final GetPendingRegistrationsUsecase getPendingRegistrationsUsecase;
  final ApproveRegistrationUsecase approveRegistrationUsecase;
  final RejectRegistrationUsecase rejectRegistrationUsecase;

  PendingRegistrationsController({
    required this.getPendingRegistrationsUsecase,
    required this.approveRegistrationUsecase,
    required this.rejectRegistrationUsecase,
  });

  // State
  final isLoading = false.obs;
  final registrations = <PendingRegistration>[].obs;
  final pagination = Rxn<Pagination>();

  // Filters
  final searchQuery = ''.obs;
  final selectedRole = 'all'.obs; // 'all', 'tenant', 'owner'
  final selectedSort = 'newest'.obs; // 'newest', 'oldest', 'name'
  final currentPage = 1.obs;
  final perPage = 20;

  @override
  void onInit() {
    super.onInit();
    loadRegistrations();
  }

  Future<void> loadRegistrations({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;

    try {
      final result = await getPendingRegistrationsUsecase.execute(
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
        role: selectedRole.value == 'all' ? null : selectedRole.value,
        sort: selectedSort.value,
        page: currentPage.value,
        perPage: perPage,
      );

      registrations.value = result.registrations;
      pagination.value = result.pagination;
      // Only show error if there's an actual error, not just empty data
      if (result.registrations.isEmpty && result.pagination.totalItems == 0) {
        // This is normal - no pending registrations, not an error
        // The empty state UI will handle this
      }
    } catch (e) {
      // Only show error snackbar for actual errors (network, server errors, etc.)
      Get.snackbar(
        'error'.tr,
        'unable_to_load_pending_registrations'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    currentPage.value = 1;
    loadRegistrations();
  }

  void onRoleFilterChanged(String? role) {
    if (role != null) {
      selectedRole.value = role;
      currentPage.value = 1;
      loadRegistrations();
    }
  }

  void onSortChanged(String? sort) {
    if (sort != null) {
      selectedSort.value = sort;
      currentPage.value = 1;
      loadRegistrations();
    }
  }

  void goToPage(int page) {
    currentPage.value = page;
    loadRegistrations();
  }

  @override
  void refresh() {
    loadRegistrations();
  }

  Future<void> approveRegistration(int userId) async {
    try {
      await approveRegistrationUsecase.execute(userId);
      Get.snackbar(
        'success'.tr,
        'registration_approved_successfully'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      // Reload to remove approved registration from list
      loadRegistrations();
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'unable_to_approve_registration'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> rejectRegistration(int userId, {String? reason}) async {
    try {
      await rejectRegistrationUsecase.execute(userId, reason: reason);
      Get.snackbar(
        'success'.tr,
        'registration_rejected_successfully'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      // Reload to remove rejected registration from list
      loadRegistrations();
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'unable_to_reject_registration'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

