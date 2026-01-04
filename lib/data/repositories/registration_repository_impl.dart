import '../../domain/entities/pending_registration.dart';
import '../../domain/entities/pagination.dart';
import '../../domain/repositories/registration_repository.dart';
import '../datasources/remote/registration_remote_datasource.dart';
import '../models/pending_registration_model.dart';
import '../models/pagination_model.dart';

class RegistrationRepositoryImpl implements RegistrationRepository {
  final RegistrationRemoteDatasource remoteDatasource;

  RegistrationRepositoryImpl(this.remoteDatasource);

  @override
  Future<({List<PendingRegistration> registrations, Pagination pagination})>
      getPendingRegistrations({
    String? search,
    String? role,
    String? sort,
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final response = await remoteDatasource.getPendingRegistrations(
        search: search,
        role: role,
        sort: sort,
        page: page,
        perPage: perPage,
      );

      final data = response['data'] as Map<String, dynamic>? ?? response;
      final registrationsList = data['registrations'] as List<dynamic>? ?? [];
      final paginationData = data['pagination'] as Map<String, dynamic>? ?? {};

      final registrations = registrationsList
          .map((json) => PendingRegistrationModel.fromJson(
                json as Map<String, dynamic>,
              ))
          .toList();

      final pagination = PaginationModel.fromJson(paginationData);

      return (registrations: registrations, pagination: pagination);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> approveRegistration(int userId) async {
    try {
      await remoteDatasource.approveRegistration(userId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> rejectRegistration(int userId, {String? reason}) async {
    try {
      await remoteDatasource.rejectRegistration(userId, reason: reason);
    } catch (e) {
      rethrow;
    }
  }
}

