import '../../entities/pending_registration.dart';
import '../../entities/pagination.dart';
import '../../repositories/registration_repository.dart';

class GetPendingRegistrationsUsecase {
  final RegistrationRepository repository;

  GetPendingRegistrationsUsecase(this.repository);

  Future<({List<PendingRegistration> registrations, Pagination pagination})>
      execute({
    String? search,
    String? role,
    String? sort,
    int page = 1,
    int perPage = 20,
  }) async {
    return await repository.getPendingRegistrations(
      search: search,
      role: role,
      sort: sort,
      page: page,
      perPage: perPage,
    );
  }
}

