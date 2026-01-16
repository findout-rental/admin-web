import '../../repositories/notification_repository.dart';

class MarkNotificationReadUsecase {
  final NotificationRepository repository;

  MarkNotificationReadUsecase(this.repository);

  Future<void> execute(int notificationId) async {
    return await repository.markAsRead(notificationId);
  }
}

