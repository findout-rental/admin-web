import '../entities/notification.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> getNotifications({
    bool unreadOnly = false,
    int page = 1,
    int perPage = 20,
  });
  
  Future<void> markAsRead(int notificationId);
  Future<void> markAllAsRead();
  Future<int> getUnreadCount();
  Future<void> updateFCMToken(String fcmToken);
}

