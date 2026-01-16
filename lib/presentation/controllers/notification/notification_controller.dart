import 'dart:async';
import 'package:get/get.dart';
import '../../../domain/entities/notification.dart';
import '../../../data/models/notification_model.dart';
import '../../../domain/usecases/notification/get_notifications_usecase.dart';
import '../../../domain/usecases/notification/mark_notification_read_usecase.dart';
import '../../../domain/usecases/notification/mark_all_read_usecase.dart';
import '../../../domain/usecases/notification/get_unread_count_usecase.dart';
import '../../../domain/usecases/notification/update_fcm_token_usecase.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/utils/app_logger.dart';
import '../../controllers/auth/auth_controller.dart';
import 'package:get_storage/get_storage.dart';

class NotificationController extends GetxController {
  final GetNotificationsUsecase getNotificationsUsecase;
  final MarkNotificationReadUsecase markNotificationReadUsecase;
  final MarkAllReadUsecase markAllReadUsecase;
  final GetUnreadCountUsecase getUnreadCountUsecase;
  final UpdateFCMTokenUsecase? updateFCMTokenUsecase;
  final GetStorage _storage = GetStorage();

  NotificationController({
    required this.getNotificationsUsecase,
    required this.markNotificationReadUsecase,
    required this.markAllReadUsecase,
    required this.getUnreadCountUsecase,
    this.updateFCMTokenUsecase,
  });

  // State
  final isLoading = false.obs;
  final notifications = <NotificationEntity>[].obs;
  final unreadCount = 0.obs;
  final isPanelOpen = false.obs;

  // Search and Filter
  final searchQuery = ''.obs;
  final showUnreadOnly = false.obs;

  Timer? _pollingTimer;
  static const Duration _pollingInterval = Duration(seconds: 30);

  @override
  void onInit() {
    super.onInit();
    // Setup Firebase message handlers
    _setupFirebaseHandlers();

    // Only load notifications if user is authenticated
    try {
      final authController = Get.find<AuthController>();
      if (authController.isAuthenticated) {
        loadNotifications();
        loadUnreadCount();
        startPolling();
        _registerFCMToken();
      }
    } catch (e) {
      // Auth controller not available - user not logged in
    }
  }

  void _setupFirebaseHandlers() {
    // Handle token refresh
    FirebaseService.onTokenRefresh = (newToken) {
      _registerFCMToken(token: newToken);
    };

    // Handle incoming messages
    FirebaseService.onMessageReceived = (payload) {
      // Reload notifications when a new message is received
      loadNotifications(showLoading: false);
      loadUnreadCount();

      // Show notification if app is in foreground
      final notification = payload['notification'] as Map<String, dynamic>?;
      if (notification != null) {
        Get.snackbar(
          notification['title'] as String? ?? 'notification'.tr,
          notification['body'] as String? ?? '',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 4),
        );
      }
    };
  }

  Future<void> _registerFCMToken({String? token}) async {
    try {
      if (updateFCMTokenUsecase == null) return;

      final fcmToken = token ?? FirebaseService.getCurrentToken();
      if (fcmToken == null) {
        AppLogger.warning('No FCM token available to register');
        return;
      }

      await updateFCMTokenUsecase!.execute(fcmToken);
      AppLogger.info('FCM token registered successfully');
    } catch (e) {
      AppLogger.error('Failed to register FCM token', error: e);
    }
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    super.onClose();
  }

  Future<void> loadNotifications({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;

    try {
      final notifs = await getNotificationsUsecase.execute(
        unreadOnly: false,
        page: 1,
        perPage: 10,
      );
      notifications.value = notifs;
    } catch (e) {
      // Silently fail - notifications are optional
      notifications.value = [];
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  Future<void> loadUnreadCount() async {
    try {
      final count = await getUnreadCountUsecase.execute();
      unreadCount.value = count;
    } catch (e) {
      // Silently fail
      unreadCount.value = 0;
    }
  }

  Future<void> markAsRead(int notificationId) async {
    try {
      await markNotificationReadUsecase.execute(notificationId);

      // Update local state
      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        final updated = NotificationModel(
          id: notifications[index].id,
          userId: notifications[index].userId,
          type: notifications[index].type,
          title: notifications[index].title,
          titleAr: notifications[index].titleAr,
          message: notifications[index].message,
          messageAr: notifications[index].messageAr,
          bookingId: notifications[index].bookingId,
          isRead: true,
          createdAt: notifications[index].createdAt,
        );
        notifications[index] = updated;
      }

      // Update unread count
      if (unreadCount.value > 0) {
        unreadCount.value--;
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'unable_to_mark_notification_read'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> markAllAsRead() async {
    if (isLoading.value) return; // Prevent multiple calls
    
    isLoading.value = true;
    try {
      await markAllReadUsecase.execute();

      // Update local state
      notifications.value = notifications.map((n) {
        if (!n.isRead) {
          return NotificationModel(
            id: n.id,
            userId: n.userId,
            type: n.type,
            title: n.title,
            titleAr: n.titleAr,
            message: n.message,
            messageAr: n.messageAr,
            bookingId: n.bookingId,
            isRead: true,
            createdAt: n.createdAt,
          );
        }
        return n;
      }).toList();

      unreadCount.value = 0;

      Get.snackbar(
        'success'.tr,
        'all_notifications_marked_read'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      AppLogger.error('Failed to mark all notifications as read', error: e);
      Get.snackbar(
        'error'.tr,
        'unable_to_mark_read'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void openPanel() {
    isPanelOpen.value = true;
    loadNotifications();
  }

  void closePanel() {
    isPanelOpen.value = false;
  }

  void togglePanel() {
    if (isPanelOpen.value) {
      closePanel();
    } else {
      openPanel();
    }
  }

  void startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(_pollingInterval, (_) {
      if (!isLoading.value) {
        loadUnreadCount();
        // Only reload notifications if panel is open
        if (isPanelOpen.value) {
          loadNotifications(showLoading: false);
        }
      }
    });
  }

  void stopPolling() {
    _pollingTimer?.cancel();
  }

  String getLocalizedTitle(NotificationEntity notification) {
    final language = _storage.read<String>(StorageKeys.language) ?? 'en';
    return notification.getLocalizedTitle(language);
  }

  String getLocalizedMessage(NotificationEntity notification) {
    final language = _storage.read<String>(StorageKeys.language) ?? 'en';
    return notification.getLocalizedMessage(language);
  }

  // Search and filter methods
  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  void toggleUnreadFilter() {
    showUnreadOnly.value = !showUnreadOnly.value;
    // Filtering is done client-side via filteredNotifications getter
    // No need to reload from server
  }

  List<NotificationEntity> get filteredNotifications {
    var filtered = List<NotificationEntity>.from(notifications);

    // Filter by unread
    if (showUnreadOnly.value) {
      filtered = filtered.where((n) => !n.isRead).toList();
    }

    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where((n) {
        final title = getLocalizedTitle(n).toLowerCase();
        final message = getLocalizedMessage(n).toLowerCase();
        return title.contains(query) || message.contains(query);
      }).toList();
    }

    return filtered;
  }
}
