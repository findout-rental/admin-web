import '../entities/pending_registration.dart';
import '../entities/pagination.dart';

abstract class RegistrationRepository {
  Future<({List<PendingRegistration> registrations, Pagination pagination})>
      getPendingRegistrations({
    String? search,
    String? role,
    String? sort,
    int page = 1,
    int perPage = 20,
  });

  Future<void> approveRegistration(int userId);
  Future<void> rejectRegistration(int userId, {String? reason});
}

