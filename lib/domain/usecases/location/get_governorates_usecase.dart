import '../../entities/governorate.dart';
import '../../repositories/location_repository.dart';

class GetGovernoratesUsecase {
  final LocationRepository repository;

  GetGovernoratesUsecase(this.repository);

  Future<List<Governorate>> execute() async {
    return await repository.getGovernorates();
  }
}

