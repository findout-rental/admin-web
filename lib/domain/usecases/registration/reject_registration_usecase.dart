import '../../repositories/registration_repository.dart';

class RejectRegistrationUsecase {
  final RegistrationRepository repository;

  RejectRegistrationUsecase(this.repository);

  Future<void> execute(int userId, {String? reason}) async {
    return await repository.rejectRegistration(userId, reason: reason);
  }
}

