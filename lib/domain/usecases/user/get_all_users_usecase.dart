import '../../entities/user.dart';
import '../../entities/user_statistics.dart';
import '../../entities/pagination.dart';
import '../../repositories/user_repository.dart';

class GetAllUsersUsecase {
  final UserRepository repository;

  GetAllUsersUsecase(this.repository);

  Future<({
    List<User> users,
    UserStatistics statistics,
    Pagination pagination,
  })> execute({
    String? search,
    String? status,
    String? role,
    String? sort,
    int page = 1,
    int perPage = 50,
  }) async {
    return await repository.getAllUsers(
      search: search,
      status: status,
      role: role,
      sort: sort,
      page: page,
      perPage: perPage,
    );
  }
}

