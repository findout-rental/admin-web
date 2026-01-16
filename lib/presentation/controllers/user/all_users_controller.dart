import 'package:get/get.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/entities/user_detail.dart';
import '../../../domain/entities/user_statistics.dart';
import '../../../domain/entities/pagination.dart';
import '../../../domain/usecases/user/get_all_users_usecase.dart';
import '../../../domain/usecases/user/get_user_detail_usecase.dart';
import '../../../domain/usecases/user/delete_user_usecase.dart';
import '../../../domain/usecases/user/deposit_money_usecase.dart';
import '../../../domain/usecases/user/withdraw_money_usecase.dart';
import '../../../domain/usecases/user/get_transaction_history_usecase.dart';

class AllUsersController extends GetxController {
  final GetAllUsersUsecase getAllUsersUsecase;
  final GetUserDetailUsecase getUserDetailUsecase;
  final DeleteUserUsecase deleteUserUsecase;
  final DepositMoneyUsecase depositMoneyUsecase;
  final WithdrawMoneyUsecase withdrawMoneyUsecase;
  final GetTransactionHistoryUsecase getTransactionHistoryUsecase;

  AllUsersController({
    required this.getAllUsersUsecase,
    required this.getUserDetailUsecase,
    required this.deleteUserUsecase,
    required this.depositMoneyUsecase,
    required this.withdrawMoneyUsecase,
    required this.getTransactionHistoryUsecase,
  });

  // List State
  final isLoading = false.obs;
  final users = <User>[].obs;
  final statistics = Rxn<UserStatistics>();
  final pagination = Rxn<Pagination>();

  // Filters
  final searchQuery = ''.obs;
  final selectedStatus = 'all'.obs; // 'all', 'approved', 'pending', 'rejected'
  final selectedRole = 'all'.obs; // 'all', 'tenant', 'owner'
  final selectedSort = 'name_asc'.obs; // 'name_asc', 'name_desc', 'newest', 'oldest'
  final currentPage = 1.obs;
  final perPage = 50;

  // Detail State
  final selectedUserId = Rxn<int>();
  final isLoadingDetail = false.obs;
  final userDetail = Rxn<UserDetail>();
  final transactionHistory = <Map<String, dynamic>>[].obs;
  
  // Transaction History Panel State
  final isTransactionHistoryPanelOpen = false.obs;
  final isLoadingTransactionHistory = false.obs;
  final selectedTransactionType = 'all'.obs; // 'all', 'deposit', 'withdrawal', 'rent_payment', 'refund', 'cancellation_fee'
  final selectedDateRange = 'all'.obs; // 'all', 'month', 'last_month', '3months'

  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }

  Future<void> loadUsers({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;

    try {
      final result = await getAllUsersUsecase.execute(
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
        status: selectedStatus.value == 'all' ? null : selectedStatus.value,
        role: selectedRole.value == 'all' ? null : selectedRole.value,
        sort: selectedSort.value,
        page: currentPage.value,
        perPage: perPage,
      );

      if (currentPage.value == 1) {
        users.value = result.users;
      } else {
        users.addAll(result.users);
      }
      statistics.value = result.statistics;
      pagination.value = result.pagination;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to load users. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  Future<void> loadUserDetail(int userId) async {
    selectedUserId.value = userId;
    isLoadingDetail.value = true;

    try {
      final detail = await getUserDetailUsecase.execute(userId);
      userDetail.value = detail;
      // Load transaction history
      await loadTransactionHistory(userId);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to load user details.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingDetail.value = false;
    }
  }

  Future<void> loadTransactionHistory(int userId) async {
    isLoadingTransactionHistory.value = true;
    try {
      final transactions = await getTransactionHistoryUsecase.execute(userId);
      transactionHistory.value = transactions;
    } catch (e) {
      // Silently fail - transaction history is optional
      transactionHistory.value = [];
    } finally {
      isLoadingTransactionHistory.value = false;
    }
  }
  
  void openTransactionHistoryPanel() {
    isTransactionHistoryPanelOpen.value = true;
  }
  
  void closeTransactionHistoryPanel() {
    isTransactionHistoryPanelOpen.value = false;
  }
  
  void onTransactionTypeFilterChanged(String? type) {
    if (type != null) {
      selectedTransactionType.value = type;
    }
  }
  
  void onDateRangeFilterChanged(String? range) {
    if (range != null) {
      selectedDateRange.value = range;
    }
  }
  
  List<Map<String, dynamic>> get filteredTransactionHistory {
    var filtered = List<Map<String, dynamic>>.from(transactionHistory);
    
    // Filter by type
    if (selectedTransactionType.value != 'all') {
      filtered = filtered.where((t) => t['type'] == selectedTransactionType.value).toList();
    }
    
    // Filter by date range
    if (selectedDateRange.value != 'all') {
      final now = DateTime.now();
      DateTime startDate;
      
      switch (selectedDateRange.value) {
        case 'month':
          startDate = DateTime(now.year, now.month, 1);
          break;
        case 'last_month':
          startDate = DateTime(now.year, now.month - 1, 1);
          break;
        case '3months':
          startDate = now.subtract(const Duration(days: 90));
          break;
        default:
          startDate = DateTime(1970);
      }
      
      filtered = filtered.where((t) {
        final createdAt = t['created_at'] as String?;
        if (createdAt == null) return false;
        try {
          final date = DateTime.parse(createdAt);
          return date.isAfter(startDate);
        } catch (e) {
          return false;
        }
      }).toList();
    }
    
    // Sort by date (newest first)
    filtered.sort((a, b) {
      final dateA = a['created_at'] as String?;
      final dateB = b['created_at'] as String?;
      if (dateA == null || dateB == null) return 0;
      try {
        return DateTime.parse(dateB).compareTo(DateTime.parse(dateA));
      } catch (e) {
        return 0;
      }
    });
    
    return filtered;
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    currentPage.value = 1;
    loadUsers();
  }

  void onStatusFilterChanged(String? status) {
    if (status != null) {
      selectedStatus.value = status;
      currentPage.value = 1;
      loadUsers();
    }
  }

  void onRoleFilterChanged(String? role) {
    if (role != null) {
      selectedRole.value = role;
      currentPage.value = 1;
      loadUsers();
    }
  }

  void onSortChanged(String? sort) {
    if (sort != null) {
      selectedSort.value = sort;
      currentPage.value = 1;
      loadUsers();
    }
  }

  void selectUser(int userId) {
    loadUserDetail(userId);
  }

  void loadMore() {
    if (pagination.value?.hasNextPage == true) {
      currentPage.value++;
      loadUsers(showLoading: false);
    }
  }

  Future<void> deleteUser(int userId) async {
    try {
      await deleteUserUsecase.execute(userId);
      Get.snackbar(
        'Success',
        'User deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
      // Remove from list
      users.removeWhere((user) => user.id == userId);
      // Clear selection if deleted user was selected
      if (selectedUserId.value == userId) {
        selectedUserId.value = null;
        userDetail.value = null;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to delete user. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> depositMoney(int userId, double amount) async {
    try {
      await depositMoneyUsecase.execute(userId, amount);
      Get.snackbar(
        'Success',
        'Money deposited successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
      // Reload user detail to update balance
      if (selectedUserId.value == userId) {
        await loadUserDetail(userId);
      }
      // Reload users list to update balance
      loadUsers();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to deposit money. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> withdrawMoney(int userId, double amount) async {
    try {
      await withdrawMoneyUsecase.execute(userId, amount);
      Get.snackbar(
        'Success',
        'Money withdrawn successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
      // Reload user detail to update balance
      if (selectedUserId.value == userId) {
        await loadUserDetail(userId);
      }
      // Reload users list to update balance
      loadUsers();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to withdraw money. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void refresh() {
    currentPage.value = 1;
    loadUsers();
    if (selectedUserId.value != null) {
      loadUserDetail(selectedUserId.value!);
    }
  }
}

