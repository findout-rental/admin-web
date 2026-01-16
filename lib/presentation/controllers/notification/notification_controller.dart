import 'dart:async';
import 'package:get/get.dart';
import '../../../domain/entities/notification.dart';
import '../../../data/models/notification_model.dart';
import '../../../domain/usecases/notification/get_notifications_usecase.dart';
import '../../../domain/usecases/notification/mark_notification_read_usecase.dart';
import '../../../domain/usecases/notification/mark_all_read_usecase.dart';
import '../../../domain/usecases/notification/get_unread_count_usecase.dart';
import '../../../core/constants/storage_keys.dart';
import '../../controllers/auth/auth_controller.dart';
import 'package:get_storage/get_storage.dart';

class NotificationController extends GetxController {
  final GetNotificationsUsecase getNotificationsUsecase;
  final MarkNotificationReadUsecase markNotificationReadUsecase;
  final MarkAllReadUsecase markAllReadUsecase;
  final GetUnreadCountUsecase getUnreadCountUsecase;
  final GetStorage _storage = GetStorage();

  NotificationController({
    required this.getNotificationsUsecase,
    required this.markNotificationReadUsecase,
    required this.markAllReadUsecase,
    required this.getUnreadCountUsecase,
  });

  // State
  final isLoading = false.obs;
  final notifications = <NotificationEntity>[].obs;
  final unreadCount = 0.obs;
  final isPanelOpen = false.obs;
  
  Timer? _pollingTimer;
  static const Duration _pollingInterval = Duration(seconds: 30);

  @override
  void onInit() {
    super.onInit();
    // Only load notifications if user is authenticated
    try {
      final authController = Get.find<AuthController>();
      if (authController.isAuthenticated) {
        loadNotifications();
        loadUnreadCount();
        startPolling();
      }
    } catch (e) {
      // Auth controller not available - user not logged in
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
        'Error',
        'Unable to mark notification as read',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> markAllAsRead() async {
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
        'Success',
        'All notifications marked as read',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to mark all as read',
        snackPosition: SnackPosition.BOTTOM,
      );
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
}

