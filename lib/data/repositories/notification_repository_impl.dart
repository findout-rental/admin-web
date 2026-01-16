import '../../domain/entities/notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/remote/notification_remote_datasource.dart';
import '../models/notification_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDatasource remoteDatasource;

  NotificationRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<NotificationEntity>> getNotifications({
    bool unreadOnly = false,
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final response = await remoteDatasource.getNotifications(
        unreadOnly: unreadOnly,
        page: page,
        perPage: perPage,
      );
      return response
          .map((json) => NotificationModel.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> markAsRead(int notificationId) async {
    try {
      await remoteDatasource.markAsRead(notificationId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      await remoteDatasource.markAllAsRead();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      return await remoteDatasource.getUnreadCount();
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<void> updateFCMToken(String fcmToken) async {
    try {
      await remoteDatasource.updateFCMToken(fcmToken);
    } catch (e) {
      rethrow;
    }
  }
}

