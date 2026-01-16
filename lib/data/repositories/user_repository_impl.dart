import '../../domain/entities/user.dart';
import '../../domain/entities/user_detail.dart';
import '../../domain/entities/user_statistics.dart';
import '../../domain/entities/pagination.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/remote/user_remote_datasource.dart';
import '../models/user_model.dart';
import '../models/user_detail_model.dart';
import '../models/user_statistics_model.dart';
import '../models/pagination_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDatasource remoteDatasource;

  UserRepositoryImpl(this.remoteDatasource);

  @override
  Future<({
    List<User> users,
    UserStatistics statistics,
    Pagination pagination,
  })> getAllUsers({
    String? search,
    String? status,
    String? role,
    String? sort,
    int page = 1,
    int perPage = 50,
  }) async {
    try {
      final response = await remoteDatasource.getAllUsers(
        search: search,
        status: status,
        role: role,
        sort: sort,
        page: page,
        perPage: perPage,
      );

      final data = response['data'] as Map<String, dynamic>? ?? response;
      final usersList = data['users'] as List<dynamic>? ?? [];
      final statisticsData = data['statistics'] as Map<String, dynamic>? ?? {};
      final paginationData = data['pagination'] as Map<String, dynamic>? ?? {};

      final users = usersList
          .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
          .toList();

      final statistics = UserStatisticsModel.fromJson(statisticsData);
      final pagination = PaginationModel.fromJson(paginationData);

      return (
        users: users,
        statistics: statistics,
        pagination: pagination,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserDetail> getUserDetail(int userId) async {
    try {
      final response = await remoteDatasource.getUserDetail(userId);
      return UserDetailModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteUser(int userId) async {
    try {
      await remoteDatasource.deleteUser(userId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> depositMoney(int userId, double amount, {String? description}) async {
    try {
      await remoteDatasource.depositMoney(userId, amount, description: description);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> withdrawMoney(int userId, double amount, {String? description}) async {
    try {
      await remoteDatasource.withdrawMoney(userId, amount, description: description);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<double> getUserBalance(int userId) async {
    try {
      return await remoteDatasource.getUserBalance(userId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getTransactionHistory(
    int userId, {
    String? type,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? sort,
    int? perPage,
  }) async {
    try {
      return await remoteDatasource.getTransactionHistory(
        userId,
        type: type,
        dateFrom: dateFrom,
        dateTo: dateTo,
        sort: sort,
        perPage: perPage,
      );
    } catch (e) {
      rethrow;
    }
  }
}

