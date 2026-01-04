import '../../repositories/user_repository.dart';

class DepositMoneyUsecase {
  final UserRepository repository;

  DepositMoneyUsecase(this.repository);

  Future<void> execute(int userId, double amount) async {
    return await repository.depositMoney(userId, amount);
  }
}

