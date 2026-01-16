import '../../domain/entities/notification.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.userId,
    required super.type,
    required super.title,
    super.titleAr,
    required super.message,
    super.messageAr,
    super.bookingId,
    super.isRead,
    required super.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      type: json['type'] as String,
      title: json['title'] as String,
      titleAr: json['title_ar'] as String?,
      message: json['message'] as String,
      messageAr: json['message_ar'] as String?,
      bookingId: json['booking_id'] as int?,
      isRead: (json['is_read'] as bool?) ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'title': title,
      if (titleAr != null) 'title_ar': titleAr,
      'message': message,
      if (messageAr != null) 'message_ar': messageAr,
      if (bookingId != null) 'booking_id': bookingId,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

