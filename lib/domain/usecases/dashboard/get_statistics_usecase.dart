import '../../entities/dashboard_statistics.dart';
import '../../repositories/dashboard_repository.dart';

class GetStatisticsUsecase {
  final DashboardRepository repository;

  GetStatisticsUsecase(this.repository);

  Future<DashboardStatistics> execute() async {
    return await repository.getStatistics();
  }
}

