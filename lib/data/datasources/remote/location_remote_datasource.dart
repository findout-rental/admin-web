import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';

abstract class LocationRemoteDatasource {
  Future<List<Map<String, dynamic>>> getGovernorates();
  Future<List<Map<String, dynamic>>> getCitiesByGovernorate(String governorate);
}

class LocationRemoteDatasourceImpl implements LocationRemoteDatasource {
  final ApiClient apiClient;

  LocationRemoteDatasourceImpl(this.apiClient);

  @override
  Future<List<Map<String, dynamic>>> getGovernorates() async {
    try {
      final response = await apiClient.get(ApiConstants.governorates);
      final data = response.data as Map<String, dynamic>;
      final governorates = data['data']?['governorates'] as List<dynamic>? ?? 
                          data['governorates'] as List<dynamic>? ?? [];
      return governorates.cast<Map<String, dynamic>>();
    } catch (e) {
      // If API doesn't exist yet, return empty list
      // TODO: Remove this fallback when API is ready
      return [];
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCitiesByGovernorate(String governorate) async {
    try {
      final response = await apiClient.get(
        ApiConstants.cities,
        queryParameters: {'governorate': governorate},
      );
      final data = response.data as Map<String, dynamic>;
      final cities = data['data']?['cities'] as List<dynamic>? ?? 
                    data['cities'] as List<dynamic>? ?? [];
      return cities.cast<Map<String, dynamic>>();
    } catch (e) {
      // If API doesn't exist yet, return empty list
      // TODO: Remove this fallback when API is ready
      return [];
    }
  }
}

