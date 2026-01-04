import 'package:equatable/equatable.dart';

class UserStatistics extends Equatable {
  final int total;
  final int approved;
  final int pending;
  final int rejected;

  const UserStatistics({
    required this.total,
    required this.approved,
    required this.pending,
    required this.rejected,
  });

  @override
  List<Object?> get props => [total, approved, pending, rejected];
}

