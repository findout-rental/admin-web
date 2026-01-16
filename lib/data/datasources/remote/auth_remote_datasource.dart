import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';

abstract class AuthRemoteDatasource {
  Future<Map<String, dynamic>> login(String mobileNumber, String password);
  Future<void> logout();
  Future<Map<String, dynamic>> getCurrentUser();
  Future<void> forgotPassword(String mobileNumber);
  Future<void> resetPassword(String token, String newPassword);
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

  @override
  Future<void> forgotPassword(String mobileNumber) async {
    await apiClient.post(
      ApiConstants.forgotPassword,
      data: {'mobile_number': mobileNumber},
    );
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    await apiClient.post(
      ApiConstants.resetPassword,
      data: {
        'token': token,
        'password': newPassword,
      },
    );
  }
}

