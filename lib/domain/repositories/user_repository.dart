import '../entities/user.dart';
import '../entities/user_detail.dart';
import '../entities/user_statistics.dart';
import '../entities/pagination.dart';

abstract class UserRepository {
  Future<({
    List<User> users,
    UserStatistics statistics,
    Pagination pagination,
  })> getAllUsers({
    String? search,
    String? status,
    String? role,
    String? sort,
    int page,
    int perPage,
  });

  Future<UserDetail> getUserDetail(int userId);
  Future<void> deleteUser(int userId);
  Future<void> depositMoney(int userId, double amount, {String? description});
  Future<void> withdrawMoney(int userId, double amount, {String? description});
  Future<double> getUserBalance(int userId);
  Future<List<Map<String, dynamic>>> getTransactionHistory(
    int userId, {
    String? type,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? sort,
    int? perPage,
  });
}

