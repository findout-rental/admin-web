import '../../domain/entities/user_statistics.dart';

class UserStatisticsModel extends UserStatistics {
  const UserStatisticsModel({
    required super.total,
    required super.approved,
    required super.pending,
    required super.rejected,
  });

  factory UserStatisticsModel.fromJson(Map<String, dynamic> json) {
    return UserStatisticsModel(
      total: json['total'] as int? ?? 0,
      approved: json['approved'] as int? ?? 0,
      pending: json['pending'] as int? ?? 0,
      rejected: json['rejected'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'approved': approved,
      'pending': pending,
      'rejected': rejected,
    };
  }
}

