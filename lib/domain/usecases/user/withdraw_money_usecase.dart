import '../../repositories/user_repository.dart';

class WithdrawMoneyUsecase {
  final UserRepository repository;

  WithdrawMoneyUsecase(this.repository);

  Future<void> execute(int userId, double amount) async {
    return await repository.withdrawMoney(userId, amount);
  }
}

