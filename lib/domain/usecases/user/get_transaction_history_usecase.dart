import '../../repositories/user_repository.dart';

class GetTransactionHistoryUsecase {
  final UserRepository repository;

  GetTransactionHistoryUsecase(this.repository);

  Future<List<Map<String, dynamic>>> execute(
    int userId, {
    String? type,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? sort,
    int? perPage,
  }) async {
    return await repository.getTransactionHistory(
      userId,
      type: type,
      dateFrom: dateFrom,
      dateTo: dateTo,
      sort: sort,
      perPage: perPage,
    );
  }
}

