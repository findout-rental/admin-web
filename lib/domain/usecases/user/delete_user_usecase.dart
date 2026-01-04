import '../../repositories/user_repository.dart';

class DeleteUserUsecase {
  final UserRepository repository;

  DeleteUserUsecase(this.repository);

  Future<void> execute(int userId) async {
    return await repository.deleteUser(userId);
  }
}

