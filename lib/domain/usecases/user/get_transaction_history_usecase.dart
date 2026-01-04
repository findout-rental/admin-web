import '../../repositories/user_repository.dart';

class GetTransactionHistoryUsecase {
  final UserRepository repository;

  GetTransactionHistoryUsecase(this.repository);

  Future<List<Map<String, dynamic>>> execute(int userId) async {
    return await repository.getTransactionHistory(userId);
  }
}

