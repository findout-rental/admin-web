import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository authRepository;

  LoginUsecase(this.authRepository);

  Future<User> execute(String mobileNumber, String password) async {
    return await authRepository.login(mobileNumber, password);
  }
}

