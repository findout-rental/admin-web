import '../../entities/apartment.dart';
import '../../entities/pagination.dart';
import '../../repositories/apartment_repository.dart';

class GetAllApartmentsUsecase {
  final ApartmentRepository repository;

  GetAllApartmentsUsecase(this.repository);

  Future<({List<Apartment> apartments, Pagination pagination})> execute({
    String? search,
    String? status,
    String? governorate,
    String? city,
    String? sort,
    int page = 1,
    int perPage = 25,
  }) async {
    return await repository.getAllApartments(
      search: search,
      status: status,
      governorate: governorate,
      city: city,
      sort: sort,
      page: page,
      perPage: perPage,
    );
  }
}

