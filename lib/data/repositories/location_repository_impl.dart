import '../../domain/entities/governorate.dart';
import '../../domain/entities/city.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/remote/location_remote_datasource.dart';
import '../models/governorate_model.dart';
import '../models/city_model.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDatasource remoteDatasource;

  LocationRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<Governorate>> getGovernorates() async {
    try {
      final response = await remoteDatasource.getGovernorates();
      return response
          .map((json) => GovernorateModel.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<City>> getCitiesByGovernorate(String governorate) async {
    try {
      final response = await remoteDatasource.getCitiesByGovernorate(governorate);
      return response
          .map((json) => CityModel.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}

