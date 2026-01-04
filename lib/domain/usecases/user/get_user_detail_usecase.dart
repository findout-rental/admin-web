import '../../entities/user_detail.dart';
import '../../repositories/user_repository.dart';

class GetUserDetailUsecase {
  final UserRepository repository;

  GetUserDetailUsecase(this.repository);

  Future<UserDetail> execute(int userId) async {
    return await repository.getUserDetail(userId);
  }
}

