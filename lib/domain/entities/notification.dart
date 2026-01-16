import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final int id;
  final int userId;
  final String type;
  final String title;
  final String? titleAr;
  final String message;
  final String? messageAr;
  final int? bookingId;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    this.titleAr,
    required this.message,
    this.messageAr,
    this.bookingId,
    this.isRead = false,
    required this.createdAt,
  });

  String getLocalizedTitle(String language) {
    return language == 'ar' && titleAr != null && titleAr!.isNotEmpty 
        ? titleAr! 
        : title;
  }

  String getLocalizedMessage(String language) {
    return language == 'ar' && messageAr != null && messageAr!.isNotEmpty 
        ? messageAr! 
        : message;
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        title,
        titleAr,
        message,
        messageAr,
        bookingId,
        isRead,
        createdAt,
      ];
}

