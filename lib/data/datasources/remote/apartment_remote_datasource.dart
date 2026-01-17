import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';

abstract class ApartmentRemoteDatasource {
  Future<Map<String, dynamic>> getAllApartments({
    String? search,
    String? status,
    String? governorate,
    String? city,
    String? sort,
    int page,
    int perPage,
  });

  Future<Map<String, dynamic>> getApartmentDetail(int apartmentId);
}

class ApartmentRemoteDatasourceImpl implements ApartmentRemoteDatasource {
  final ApiClient apiClient;

  ApartmentRemoteDatasourceImpl(this.apiClient);

  @override
  Future<Map<String, dynamic>> getAllApartments({
    String? search,
    String? status,
    String? governorate,
    String? city,
    String? sort,
    int page = 1,
    int perPage = 25,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    if (status != null && status.isNotEmpty && status != 'all') {
      queryParams['status'] = status;
    }
    if (governorate != null && governorate.isNotEmpty) {
      queryParams['governorate'] = governorate;
    }
    if (city != null && city.isNotEmpty) {
      queryParams['city'] = city;
    }
    if (sort != null && sort.isNotEmpty) {
      queryParams['sort'] = sort;
    }

    final response = await apiClient.get(
      ApiConstants.allApartments,
      queryParameters: queryParams,
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getApartmentDetail(int apartmentId) async {
    final response = await apiClient.get('${ApiConstants.apartmentDetail}/$apartmentId');
    return response.data as Map<String, dynamic>;
  }
}

