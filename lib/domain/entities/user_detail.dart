import 'package:equatable/equatable.dart';

class UserDetail extends Equatable {
  final int id;
  final String mobileNumber;
  final String firstName;
  final String lastName;
  final String? personalPhoto;
  final String? idPhoto;
  final DateTime? dateOfBirth;
  final String role; // 'tenant' or 'owner'
  final String status; // 'approved', 'pending', 'rejected'
  final DateTime createdAt;
  final double balance;
  final UserActivitySummary? activitySummary;
  final int activeBookingsCount;

  const UserDetail({
    required this.id,
    required this.mobileNumber,
    required this.firstName,
    required this.lastName,
    this.personalPhoto,
    this.idPhoto,
    this.dateOfBirth,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.balance,
    this.activitySummary,
    required this.activeBookingsCount,
  });

  String get fullName => '$firstName $lastName';

  bool get canDelete => activeBookingsCount == 0;

  @override
  List<Object?> get props => [
        id,
        mobileNumber,
        firstName,
        lastName,
        personalPhoto,
        idPhoto,
        dateOfBirth,
        role,
        status,
        createdAt,
        balance,
        activitySummary,
        activeBookingsCount,
      ];
}

class UserActivitySummary extends Equatable {
  // For tenants
  final int? totalBookings;
  final int? activeBookings;
  final int? completedBookings;
  final int? reviewsGiven;

  // For owners
  final int? totalApartments;
  final int? activeApartments;
  final int? totalBookingsReceived;
  final double? averageRating;

  const UserActivitySummary({
    this.totalBookings,
    this.activeBookings,
    this.completedBookings,
    this.reviewsGiven,
    this.totalApartments,
    this.activeApartments,
    this.totalBookingsReceived,
    this.averageRating,
  });

  @override
  List<Object?> get props => [
        totalBookings,
        activeBookings,
        completedBookings,
        reviewsGiven,
        totalApartments,
        activeApartments,
        totalBookingsReceived,
        averageRating,
      ];
}

