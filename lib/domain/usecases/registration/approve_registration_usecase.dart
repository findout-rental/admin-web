import '../../repositories/registration_repository.dart';

class ApproveRegistrationUsecase {
  final RegistrationRepository repository;

  ApproveRegistrationUsecase(this.repository);

  Future<void> execute(int userId) async {
    return await repository.approveRegistration(userId);
  }
}

