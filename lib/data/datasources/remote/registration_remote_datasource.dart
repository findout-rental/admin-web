import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';

abstract class RegistrationRemoteDatasource {
  Future<Map<String, dynamic>> getPendingRegistrations({
    String? search,
    String? role,
    String? sort,
    int page,
    int perPage,
  });

  Future<void> approveRegistration(int userId);
  Future<void> rejectRegistration(int userId, {String? reason});
}

class RegistrationRemoteDatasourceImpl
    implements RegistrationRemoteDatasource {
  final ApiClient apiClient;

  RegistrationRemoteDatasourceImpl(this.apiClient);

  @override
  Future<Map<String, dynamic>> getPendingRegistrations({
    String? search,
    String? role,
    String? sort,
    int page = 1,
    int perPage = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    if (role != null && role.isNotEmpty && role != 'all') {
      queryParams['role'] = role;
    }
    if (sort != null && sort.isNotEmpty) {
      queryParams['sort'] = sort;
    }

    final response = await apiClient.get(
      ApiConstants.pendingRegistrations,
      queryParameters: queryParams,
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<void> approveRegistration(int userId) async {
    await apiClient.put(
      '${ApiConstants.approveRegistration}/$userId/approve',
    );
  }

  @override
  Future<void> rejectRegistration(int userId, {String? reason}) async {
    await apiClient.put(
      '${ApiConstants.rejectRegistration}/$userId/reject',
      data: reason != null ? {'rejection_reason': reason} : null,
    );
  }
}

