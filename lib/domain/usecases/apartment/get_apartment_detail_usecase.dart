import '../../repositories/apartment_repository.dart';

class GetApartmentDetailUsecase {
  final ApartmentRepository repository;

  GetApartmentDetailUsecase(this.repository);

  Future<Map<String, dynamic>> execute(int apartmentId) async {
    return await repository.getApartmentDetail(apartmentId);
  }
}

