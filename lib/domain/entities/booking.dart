import 'package:equatable/equatable.dart';

class Booking extends Equatable {
  final int id;
  final int tenantId;
  final String tenantName;
  final String? tenantPhoto;
  final int apartmentId;
  final String apartmentAddress;
  final int ownerId;
  final String ownerName;
  final String? ownerPhoto;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int duration; // in days/nights
  final double totalPrice;
  final String status; // 'pending', 'approved', 'active', 'completed', 'cancelled', 'rejected'
  final DateTime createdAt;

  const Booking({
    required this.id,
    required this.tenantId,
    required this.tenantName,
    this.tenantPhoto,
    required this.apartmentId,
    required this.apartmentAddress,
    required this.ownerId,
    required this.ownerName,
    this.ownerPhoto,
    required this.checkInDate,
    required this.checkOutDate,
    required this.duration,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        tenantId,
        tenantName,
        tenantPhoto,
        apartmentId,
        apartmentAddress,
        ownerId,
        ownerName,
        ownerPhoto,
        checkInDate,
        checkOutDate,
        duration,
        totalPrice,
        status,
        createdAt,
      ];
}

