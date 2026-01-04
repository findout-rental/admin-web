import '../entities/apartment.dart';
import '../entities/pagination.dart';

abstract class ApartmentRepository {
  Future<({List<Apartment> apartments, Pagination pagination})> getAllApartments({
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

