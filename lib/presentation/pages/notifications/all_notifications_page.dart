import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../widgets/layout/app_scaffold.dart';
import '../../controllers/notification/notification_controller.dart';
import '../../../domain/entities/notification.dart';

class AllNotificationsPage extends StatelessWidget {
  const AllNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
      builder: (controller) {
        return AppScaffold(
          title: 'All Notifications',
          child: Column(
            children: [
              // Header with Actions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[200]!),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      'Notifications',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Spacer(),
                    Obx(() {
                      if (controller.unreadCount.value > 0) {
                        return TextButton.icon(
                          onPressed: controller.markAllAsRead,
                          icon: const Icon(Icons.done_all, size: 18),
                          label: Text('Mark All as Read (${controller.unreadCount.value})'),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ),
              ),

              // Filters
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[200]!),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search notifications...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onChanged: (value) {
                          // TODO: Implement search functionality
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Obx(() {
                      return FilterChip(
                        selected: false,
                        label: const Text('Unread Only'),
                        onSelected: (selected) {
                          // TODO: Implement filter
                        },
                      );
                    }),
                  ],
                ),
              ),

              // Notifications List
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value && controller.notifications.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.notifications.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications_none, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'No notifications',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'You\'re all caught up!',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[500],
                                ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => controller.loadNotifications(),
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.notifications.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final notification = controller.notifications[index];
                        return _buildNotificationItem(context, controller, notification);
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    NotificationController controller,
    NotificationEntity notification,
  ) {
    final isUnread = !notification.isRead;
    final title = controller.getLocalizedTitle(notification);
    final message = controller.getLocalizedMessage(notification);

    return InkWell(
      onTap: () {
        if (isUnread) {
          controller.markAsRead(notification.id);
        }
        // Navigate to related content if applicable
        if (notification.bookingId != null) {
          Get.toNamed('/bookings');
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUnread ? Colors.blue[50] : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getNotificationColor(notification.type).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getNotificationIcon(notification.type),
                color: _getNotificationColor(notification.type),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('MMM dd, yyyy - HH:mm').format(notification.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                      if (notification.bookingId != null) ...[
                        const SizedBox(width: 16),
                        Icon(Icons.link, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          'Related to booking',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Actions
            if (isUnread)
              IconButton(
                icon: const Icon(Icons.check_circle_outline),
                onPressed: () => controller.markAsRead(notification.id),
                tooltip: 'Mark as read',
                color: Colors.grey[600],
              ),
          ],
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'registration_request':
        return Icons.person_add;
      case 'booking_approved':
      case 'booking_rejected':
        return Icons.calendar_today;
      case 'new_message':
        return Icons.message;
      case 'system_update':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'registration_request':
        return Colors.orange;
      case 'booking_approved':
        return Colors.green;
      case 'booking_rejected':
        return Colors.red;
      case 'new_message':
        return Colors.blue;
      case 'system_update':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

