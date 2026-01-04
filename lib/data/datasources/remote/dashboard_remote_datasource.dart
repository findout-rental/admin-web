import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';

abstract class DashboardRemoteDatasource {
  Future<Map<String, dynamic>> getStatistics();
}

class DashboardRemoteDatasourceImpl implements DashboardRemoteDatasource {
  final ApiClient apiClient;

  DashboardRemoteDatasourceImpl(this.apiClient);

  @override
  Future<Map<String, dynamic>> getStatistics() async {
    final response = await apiClient.get(ApiConstants.dashboardStats);
    return response.data as Map<String, dynamic>;
  }
}

