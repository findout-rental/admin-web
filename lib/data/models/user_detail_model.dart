import '../../domain/entities/user_detail.dart';

class UserDetailModel extends UserDetail {
  const UserDetailModel({
    required super.id,
    required super.mobileNumber,
    required super.firstName,
    required super.lastName,
    super.personalPhoto,
    super.idPhoto,
    super.dateOfBirth,
    required super.role,
    required super.status,
    required super.createdAt,
    required super.balance,
    super.activitySummary,
    required super.activeBookingsCount,
  });

  factory UserDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final userData = data['user'] as Map<String, dynamic>? ?? data;

    return UserDetailModel(
      id: userData['id'] as int,
      mobileNumber: userData['mobile_number'] as String,
      firstName: userData['first_name'] as String,
      lastName: userData['last_name'] as String,
      personalPhoto: userData['personal_photo'] as String?,
      idPhoto: userData['id_photo'] as String?,
      dateOfBirth: userData['date_of_birth'] != null
          ? DateTime.parse(userData['date_of_birth'] as String)
          : null,
      role: userData['role'] as String,
      status: userData['status'] as String,
      createdAt: userData['created_at'] != null
          ? DateTime.parse(userData['created_at'] as String)
          : DateTime.now(),
      balance: userData['balance'] != null
          ? (userData['balance'] is String
              ? double.tryParse(userData['balance'] as String) ?? 0.0
              : (userData['balance'] as num).toDouble())
          : 0.0,
      activitySummary: userData['activity_summary'] != null
          ? UserActivitySummaryModel.fromJson(
              userData['activity_summary'] as Map<String, dynamic>,
            )
          : null,
      activeBookingsCount: userData['active_bookings_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mobile_number': mobileNumber,
      'first_name': firstName,
      'last_name': lastName,
      'personal_photo': personalPhoto,
      'id_photo': idPhoto,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'role': role,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'balance': balance,
      'activity_summary': activitySummary != null
          ? (activitySummary as UserActivitySummaryModel).toJson()
          : null,
      'active_bookings_count': activeBookingsCount,
    };
  }
}

class UserActivitySummaryModel extends UserActivitySummary {
  const UserActivitySummaryModel({
    super.totalBookings,
    super.activeBookings,
    super.completedBookings,
    super.reviewsGiven,
    super.totalApartments,
    super.activeApartments,
    super.totalBookingsReceived,
    super.averageRating,
  });

  factory UserActivitySummaryModel.fromJson(Map<String, dynamic> json) {
    return UserActivitySummaryModel(
      totalBookings: json['total_bookings'] as int?,
      activeBookings: json['active_bookings'] as int?,
      completedBookings: json['completed_bookings'] as int?,
      reviewsGiven: json['reviews_given'] as int?,
      totalApartments: json['total_apartments'] as int?,
      activeApartments: json['active_apartments'] as int?,
      totalBookingsReceived: json['total_bookings_received'] as int?,
      averageRating: json['average_rating'] != null
          ? (json['average_rating'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_bookings': totalBookings,
      'active_bookings': activeBookings,
      'completed_bookings': completedBookings,
      'reviews_given': reviewsGiven,
      'total_apartments': totalApartments,
      'active_apartments': activeApartments,
      'total_bookings_received': totalBookingsReceived,
      'average_rating': averageRating,
    };
  }
}

