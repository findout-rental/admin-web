import '../../domain/entities/apartment.dart';

class ApartmentModel extends Apartment {
  const ApartmentModel({
    required super.id,
    required super.address,
    super.governorate,
    super.city,
    super.price,
    super.pricePeriod,
    required super.status,
    super.averageRating,
    super.totalRatings,
    required super.totalBookings,
    required super.createdAt,
    required super.ownerId,
    required super.ownerName,
    super.ownerPhoto,
    super.mainPhoto,
    super.photos,
  });

  factory ApartmentModel.fromJson(Map<String, dynamic> json) {
    final owner = json['owner'] as Map<String, dynamic>? ?? {};
    
    return ApartmentModel(
      id: json['id'] as int,
      address: json['address'] as String? ?? 'N/A',
      governorate: json['governorate'] as String?,
      city: json['city'] as String?,
      price: json['price'] != null
          ? (json['price'] is String
              ? double.tryParse(json['price'] as String)
              : (json['price'] as num?)?.toDouble())
          : null,
      pricePeriod: json['price_period'] as String?,
      status: json['status'] as String? ?? 'inactive',
      averageRating: json['average_rating'] != null
          ? (json['average_rating'] as num).toDouble()
          : null,
      totalRatings: json['total_ratings'] as int?,
      totalBookings: json['total_bookings'] as int? ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      ownerId: owner['id'] as int? ?? json['owner_id'] as int? ?? 0,
      ownerName: owner['name'] as String? ??
          '${owner['first_name'] ?? ''} ${owner['last_name'] ?? ''}'.trim(),
      ownerPhoto: owner['personal_photo'] as String?,
      mainPhoto: json['main_photo'] as String? ??
          (json['photos'] != null && (json['photos'] as List<dynamic>).isNotEmpty
              ? (json['photos'] as List<dynamic>).first as String?
              : null),
      photos: json['photos'] != null
          ? (json['photos'] as List<dynamic>).cast<String>()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'governorate': governorate,
      'city': city,
      'price': price,
      'price_period': pricePeriod,
      'status': status,
      'average_rating': averageRating,
      'total_ratings': totalRatings,
      'total_bookings': totalBookings,
      'created_at': createdAt.toIso8601String(),
      'owner_id': ownerId,
      'owner': {
        'id': ownerId,
        'name': ownerName,
        'personal_photo': ownerPhoto,
      },
      'main_photo': mainPhoto,
      'photos': photos,
    };
  }
}

