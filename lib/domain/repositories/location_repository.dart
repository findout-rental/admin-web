import '../entities/governorate.dart';
import '../entities/city.dart';

abstract class LocationRepository {
  Future<List<Governorate>> getGovernorates();
  Future<List<City>> getCitiesByGovernorate(String governorate);
}

