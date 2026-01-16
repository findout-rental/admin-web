import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/notification/notification_controller.dart';
import '../../../domain/entities/notification.dart';

class NotificationPanel extends StatelessWidget {
  const NotificationPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
      builder: (controller) {
        return Container(
          width: 400,
          constraints: const BoxConstraints(maxHeight: 600),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              _buildHeader(context, controller),
              
              // Notifications List
              Flexible(
                child: _buildNotificationsList(context, controller),
              ),
              
              // Footer
              _buildFooter(context, controller),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, NotificationController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
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
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${controller.unreadCount.value}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: controller.closePanel,
            tooltip: 'Close',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(
      BuildContext context, NotificationController controller) {
    return Obx(() {
      if (controller.isLoading.value && controller.notifications.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (controller.notifications.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.notifications_none, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No notifications',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You\'re all caught up!',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                ),
              ],
            ),
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        itemCount: controller.notifications.length,
        separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey[200]),
        itemBuilder: (context, index) {
          final notification = controller.notifications[index];
          return _buildNotificationItem(context, controller, notification);
        },
      );
    });
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
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUnread ? Colors.blue[50] : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getNotificationColor(notification.type).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getNotificationIcon(notification.type),
                color: _getNotificationColor(notification.type),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            
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
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM dd, yyyy - HH:mm').format(notification.createdAt),
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(
      BuildContext context, NotificationController controller) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                controller.markAllAsRead();
              },
              child: const Text('Mark All as Read'),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {
              controller.closePanel();
              Get.toNamed('/notifications');
            },
            child: const Text('View All'),
          ),
        ],
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

