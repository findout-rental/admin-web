import 'package:equatable/equatable.dart';

class DashboardStatistics extends Equatable {
  final UserStatistics users;
  final ApartmentStatistics apartments;
  final BookingStatistics bookings;
  final DateTime lastUpdated;

  const DashboardStatistics({
    required this.users,
    required this.apartments,
    required this.bookings,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [users, apartments, bookings, lastUpdated];
}

class UserStatistics extends Equatable {
  final int total;
  final int tenants;
  final int owners;
  final int pending;

  const UserStatistics({
    required this.total,
    required this.tenants,
    required this.owners,
    required this.pending,
  });

  @override
  List<Object?> get props => [total, tenants, owners, pending];
}

class ApartmentStatistics extends Equatable {
  final int total;
  final int active;
  final int inactive;

  const ApartmentStatistics({
    required this.total,
    required this.active,
    required this.inactive,
  });

  @override
  List<Object?> get props => [total, active, inactive];
}

class BookingStatistics extends Equatable {
  final int total;
  final int active;
  final int completed;

  const BookingStatistics({
    required this.total,
    required this.active,
    required this.completed,
  });

  @override
  List<Object?> get props => [total, active, completed];
}

