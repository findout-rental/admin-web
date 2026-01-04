import '../../repositories/auth_repository.dart';

class LogoutUsecase {
  final AuthRepository authRepository;

  LogoutUsecase(this.authRepository);

  Future<void> execute() async {
    await authRepository.logout();
  }
}

