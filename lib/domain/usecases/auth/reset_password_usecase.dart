import '../../repositories/auth_repository.dart';

class ResetPasswordUsecase {
  final AuthRepository repository;

  ResetPasswordUsecase(this.repository);

  Future<void> execute(String token, String newPassword) async {
    return await repository.resetPassword(token, newPassword);
  }
}

