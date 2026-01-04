import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';

abstract class AuthRemoteDatasource {
  Future<Map<String, dynamic>> login(String mobileNumber, String password);
  Future<void> logout();
  Future<Map<String, dynamic>> getCurrentUser();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final ApiClient apiClient;

  AuthRemoteDatasourceImpl(this.apiClient);

  @override
  Future<Map<String, dynamic>> login(String mobileNumber, String password) async {
    final response = await apiClient.post(
      ApiConstants.login,
      data: {
        'mobile_number': mobileNumber,
        'password': password,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<void> logout() async {
    await apiClient.post(ApiConstants.logout);
  }

  @override
  Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await apiClient.get(ApiConstants.me);
    return response.data as Map<String, dynamic>;
  }
}

