import '../../repositories/auth_repository.dart';

class ForgotPasswordUsecase {
  final AuthRepository repository;

  ForgotPasswordUsecase(this.repository);

  Future<void> execute(String mobileNumber) async {
    return await repository.forgotPassword(mobileNumber);
  }
}

