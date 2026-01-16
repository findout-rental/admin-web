import '../../repositories/notification_repository.dart';

class GetUnreadCountUsecase {
  final NotificationRepository repository;

  GetUnreadCountUsecase(this.repository);

  Future<int> execute() async {
    return await repository.getUnreadCount();
  }
}

