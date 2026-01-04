import 'package:equatable/equatable.dart';

class Apartment extends Equatable {
  final int id;
  final String address;
  final String? governorate;
  final String? city;
  final double? price;
  final String? pricePeriod; // 'per_night', 'per_month', etc.
  final String status; // 'active', 'inactive'
  final double? averageRating;
  final int? totalRatings;
  final int totalBookings;
  final DateTime createdAt;
  final int ownerId;
  final String ownerName;
  final String? ownerPhoto;
  final String? mainPhoto;
  final List<String>? photos;

  const Apartment({
    required this.id,
    required this.address,
    this.governorate,
    this.city,
    this.price,
    this.pricePeriod,
    required this.status,
    this.averageRating,
    this.totalRatings,
    required this.totalBookings,
    required this.createdAt,
    required this.ownerId,
    required this.ownerName,
    this.ownerPhoto,
    this.mainPhoto,
    this.photos,
  });

  String get location {
    if (city != null && governorate != null) {
      return '$city, $governorate';
    } else if (city != null) {
      return city!;
    } else if (governorate != null) {
      return governorate!;
    }
    return 'N/A';
  }

  @override
  List<Object?> get props => [
        id,
        address,
        governorate,
        city,
        price,
        pricePeriod,
        status,
        averageRating,
        totalRatings,
        totalBookings,
        createdAt,
        ownerId,
        ownerName,
        ownerPhoto,
        mainPhoto,
        photos,
      ];
}

