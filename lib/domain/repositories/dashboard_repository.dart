import '../entities/dashboard_statistics.dart';

abstract class DashboardRepository {
  Future<DashboardStatistics> getStatistics();
}

