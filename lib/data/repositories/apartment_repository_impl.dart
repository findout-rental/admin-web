import '../../domain/entities/apartment.dart';
import '../../domain/entities/pagination.dart';
import '../../domain/repositories/apartment_repository.dart';
import '../datasources/remote/apartment_remote_datasource.dart';
import '../models/apartment_model.dart';
import '../models/pagination_model.dart';

class ApartmentRepositoryImpl implements ApartmentRepository {
  final ApartmentRemoteDatasource remoteDatasource;

  ApartmentRepositoryImpl(this.remoteDatasource);

  @override
  Future<({List<Apartment> apartments, Pagination pagination})> getAllApartments({
    String? search,
    String? status,
    String? governorate,
    String? city,
    String? sort,
    int page = 1,
    int perPage = 25,
  }) async {
    try {
      final response = await remoteDatasource.getAllApartments(
        search: search,
        status: status,
        governorate: governorate,
        city: city,
        sort: sort,
        page: page,
        perPage: perPage,
      );

      final data = response['data'] as Map<String, dynamic>? ?? response;
      final apartmentsList = data['apartments'] as List<dynamic>? ?? [];
      final paginationData = data['pagination'] as Map<String, dynamic>? ?? {};

      final apartments = apartmentsList
          .map((json) => ApartmentModel.fromJson(json as Map<String, dynamic>))
          .toList();

      final pagination = PaginationModel.fromJson(paginationData);

      return (apartments: apartments, pagination: pagination);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getApartmentDetail(int apartmentId) async {
    try {
      final response = await remoteDatasource.getApartmentDetail(apartmentId);
      // Handle response wrapper: {success: true, data: {...}} or direct {...}
      return response['data'] as Map<String, dynamic>? ?? response;
    } catch (e) {
      rethrow;
    }
  }
}

