import '../../domain/entities/dashboard_statistics.dart';

class DashboardStatisticsModel extends DashboardStatistics {
  const DashboardStatisticsModel({
    required super.users,
    required super.apartments,
    required super.bookings,
    required super.lastUpdated,
  });

  factory DashboardStatisticsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    
    return DashboardStatisticsModel(
      users: UserStatisticsModel.fromJson(data['users'] as Map<String, dynamic>),
      apartments: ApartmentStatisticsModel.fromJson(
        data['apartments'] as Map<String, dynamic>,
      ),
      bookings: BookingStatisticsModel.fromJson(
        data['bookings'] as Map<String, dynamic>,
      ),
      lastUpdated: data['last_updated'] != null
          ? DateTime.parse(data['last_updated'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'users': (users as UserStatisticsModel).toJson(),
      'apartments': (apartments as ApartmentStatisticsModel).toJson(),
      'bookings': (bookings as BookingStatisticsModel).toJson(),
      'last_updated': lastUpdated.toIso8601String(),
    };
  }
}

class UserStatisticsModel extends UserStatistics {
  const UserStatisticsModel({
    required super.total,
    required super.tenants,
    required super.owners,
    required super.pending,
  });

  factory UserStatisticsModel.fromJson(Map<String, dynamic> json) {
    return UserStatisticsModel(
      total: json['total'] as int? ?? 0,
      tenants: json['tenants'] as int? ?? 0,
      owners: json['owners'] as int? ?? 0,
      pending: json['pending'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'tenants': tenants,
      'owners': owners,
      'pending': pending,
    };
  }
}

class ApartmentStatisticsModel extends ApartmentStatistics {
  const ApartmentStatisticsModel({
    required super.total,
    required super.active,
    required super.inactive,
  });

  factory ApartmentStatisticsModel.fromJson(Map<String, dynamic> json) {
    return ApartmentStatisticsModel(
      total: json['total'] as int? ?? 0,
      active: json['active'] as int? ?? 0,
      inactive: json['inactive'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'active': active,
      'inactive': inactive,
    };
  }
}

class BookingStatisticsModel extends BookingStatistics {
  const BookingStatisticsModel({
    required super.total,
    required super.active,
    required super.completed,
  });

  factory BookingStatisticsModel.fromJson(Map<String, dynamic> json) {
    return BookingStatisticsModel(
      total: json['total'] as int? ?? 0,
      active: json['active'] as int? ?? 0,
      completed: json['completed'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'active': active,
      'completed': completed,
    };
  }
}

