import '../../repositories/notification_repository.dart';

class MarkAllReadUsecase {
  final NotificationRepository repository;

  MarkAllReadUsecase(this.repository);

  Future<void> execute() async {
    return await repository.markAllAsRead();
  }
}

