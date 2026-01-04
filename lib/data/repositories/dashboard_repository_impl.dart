import '../../domain/entities/dashboard_statistics.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/remote/dashboard_remote_datasource.dart';
import '../models/dashboard_statistics_model.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDatasource remoteDatasource;

  DashboardRepositoryImpl(this.remoteDatasource);

  @override
  Future<DashboardStatistics> getStatistics() async {
    try {
      final response = await remoteDatasource.getStatistics();
      return DashboardStatisticsModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}

