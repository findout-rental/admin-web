import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';

abstract class NotificationRemoteDatasource {
  Future<List<Map<String, dynamic>>> getNotifications({
    bool unreadOnly = false,
    int page = 1,
    int perPage = 20,
  });
  
  Future<void> markAsRead(int notificationId);
  Future<void> markAllAsRead();
  Future<int> getUnreadCount();
  Future<void> updateFCMToken(String fcmToken);
}

class NotificationRemoteDatasourceImpl implements NotificationRemoteDatasource {
  final ApiClient apiClient;

  NotificationRemoteDatasourceImpl(this.apiClient);

  @override
  Future<List<Map<String, dynamic>>> getNotifications({
    bool unreadOnly = false,
    int page = 1,
    int perPage = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      if (unreadOnly) 'unread_only': true,
    };

    final response = await apiClient.get(
      ApiConstants.notifications,
      queryParameters: queryParams,
    );
    
    final data = response.data as Map<String, dynamic>;
    final notifications = data['data']?['notifications'] as List<dynamic>? ?? 
                         data['notifications'] as List<dynamic>? ?? [];
    return notifications.cast<Map<String, dynamic>>();
  }

  @override
  Future<void> markAsRead(int notificationId) async {
    await apiClient.put('${ApiConstants.markNotificationRead}/$notificationId/read');
  }

  @override
  Future<void> markAllAsRead() async {
    await apiClient.put(ApiConstants.markAllRead);
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      final response = await apiClient.get(
        ApiConstants.notifications,
        queryParameters: {'unread_only': true, 'per_page': 1},
      );
      final data = response.data as Map<String, dynamic>;
      final pagination = data['data']?['pagination'] as Map<String, dynamic>? ?? 
                        data['pagination'] as Map<String, dynamic>? ?? {};
      return (pagination['total'] as int?) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<void> updateFCMToken(String fcmToken) async {
    await apiClient.post(
      ApiConstants.updateFCMToken,
      data: {'fcm_token': fcmToken},
    );
  }
}

