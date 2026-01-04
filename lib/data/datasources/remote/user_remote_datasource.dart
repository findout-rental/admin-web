import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';

abstract class UserRemoteDatasource {
  Future<Map<String, dynamic>> getAllUsers({
    String? search,
    String? status,
    String? role,
    String? sort,
    int page,
    int perPage,
  });

  Future<Map<String, dynamic>> getUserDetail(int userId);
  Future<void> deleteUser(int userId);
  Future<void> depositMoney(int userId, double amount);
  Future<void> withdrawMoney(int userId, double amount);
  Future<List<Map<String, dynamic>>> getTransactionHistory(int userId);
}

class UserRemoteDatasourceImpl implements UserRemoteDatasource {
  final ApiClient apiClient;

  UserRemoteDatasourceImpl(this.apiClient);

  @override
  Future<Map<String, dynamic>> getAllUsers({
    String? search,
    String? status,
    String? role,
    String? sort,
    int page = 1,
    int perPage = 50,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    if (status != null && status.isNotEmpty && status != 'all') {
      queryParams['status'] = status;
    }
    if (role != null && role.isNotEmpty && role != 'all') {
      queryParams['role'] = role;
    }
    if (sort != null && sort.isNotEmpty) {
      queryParams['sort'] = sort;
    }

    final response = await apiClient.get(
      ApiConstants.allUsers,
      queryParameters: queryParams,
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getUserDetail(int userId) async {
    final response = await apiClient.get('${ApiConstants.userDetail}/$userId');
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<void> deleteUser(int userId) async {
    await apiClient.delete('${ApiConstants.deleteUser}/$userId');
  }

  @override
  Future<void> depositMoney(int userId, double amount) async {
    await apiClient.post(
      '${ApiConstants.userDeposit}/$userId/deposit',
      data: {'amount': amount},
    );
  }

  @override
  Future<void> withdrawMoney(int userId, double amount) async {
    await apiClient.post(
      '${ApiConstants.userWithdraw}/$userId/withdraw',
      data: {'amount': amount},
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getTransactionHistory(int userId) async {
    final response = await apiClient.get(
      '${ApiConstants.userTransactions}/$userId/transactions',
    );
    final data = response.data as Map<String, dynamic>;
    final transactions = data['data']?['transactions'] as List<dynamic>? ?? [];
    return transactions.cast<Map<String, dynamic>>();
  }
}

