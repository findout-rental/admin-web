import '../../entities/notification.dart';
import '../../repositories/notification_repository.dart';

class GetNotificationsUsecase {
  final NotificationRepository repository;

  GetNotificationsUsecase(this.repository);

  Future<List<NotificationEntity>> execute({
    bool unreadOnly = false,
    int page = 1,
    int perPage = 20,
  }) async {
    return await repository.getNotifications(
      unreadOnly: unreadOnly,
      page: page,
      perPage: perPage,
    );
  }
}

