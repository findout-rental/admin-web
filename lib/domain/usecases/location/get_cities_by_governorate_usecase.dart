import '../../entities/city.dart';
import '../../repositories/location_repository.dart';

class GetCitiesByGovernorateUsecase {
  final LocationRepository repository;

  GetCitiesByGovernorateUsecase(this.repository);

  Future<List<City>> execute(String governorate) async {
    return await repository.getCitiesByGovernorate(governorate);
  }
}

