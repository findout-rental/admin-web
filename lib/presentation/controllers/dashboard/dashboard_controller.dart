import 'package:get/get.dart';
import '../../../domain/entities/dashboard_statistics.dart';
import '../../../domain/usecases/dashboard/get_statistics_usecase.dart';

class DashboardController extends GetxController {
  final GetStatisticsUsecase getStatisticsUsecase;

  DashboardController(this.getStatisticsUsecase);

  // Statistics
  final isLoading = true.obs;
  final statistics = Rxn<DashboardStatistics>();

  // Statistics data
  final totalUsers = 0.obs;
  final totalTenants = 0.obs;
  final totalOwners = 0.obs;
  final totalApartments = 0.obs;
  final activeApartments = 0.obs;
  final inactiveApartments = 0.obs;
  final pendingRegistrations = 0.obs;
  final totalBookings = 0.obs;
  final activeBookings = 0.obs;
  final completedBookings = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadStatistics();
    // Auto-refresh every 60 seconds
    // Timer.periodic(const Duration(seconds: 60), (_) => loadStatistics());
  }

  Future<void> loadStatistics() async {
    isLoading.value = true;
    try {
      final stats = await getStatisticsUsecase.execute();
      statistics.value = stats;
      _updateObservableValues(stats);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to load dashboard data. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _updateObservableValues(DashboardStatistics stats) {
    totalUsers.value = stats.users.total;
    totalTenants.value = stats.users.tenants;
    totalOwners.value = stats.users.owners;
    totalApartments.value = stats.apartments.total;
    activeApartments.value = stats.apartments.active;
    inactiveApartments.value = stats.apartments.inactive;
    pendingRegistrations.value = stats.users.pending;
    totalBookings.value = stats.bookings.total;
    activeBookings.value = stats.bookings.active;
    completedBookings.value = stats.bookings.completed;
  }

  void refreshStatistics() {
    loadStatistics();
  }
}

