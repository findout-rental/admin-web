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
    
    // Backend sends nightly_price and monthly_price as formatted strings
    // Use nightly_price as default price, or monthly_price if nightly is not available
    final nightlyPriceStr = json['nightly_price'] as String?;
    final monthlyPriceStr = json['monthly_price'] as String?;
    double? price;
    String? pricePeriod;
    
    if (nightlyPriceStr != null) {
      // Remove formatting (commas) and parse
      final cleaned = nightlyPriceStr.replaceAll(',', '');
      price = double.tryParse(cleaned);
      pricePeriod = 'nightly';
    } else if (monthlyPriceStr != null) {
      final cleaned = monthlyPriceStr.replaceAll(',', '');
      price = double.tryParse(cleaned);
      pricePeriod = 'monthly';
    }
    
    // Get first photo as main photo
    final photosList = json['photos'] as List<dynamic>? ?? [];
    final mainPhoto = photosList.isNotEmpty ? photosList.first as String? : null;
    
    // Convert relative photo URLs to full URLs if needed
    String? convertPhotoUrl(String? url) {
      if (url == null || url.isEmpty) return null;
      if (url.startsWith('http')) return url;
      // If relative path, prepend base URL
      final baseUrl = 'http://localhost:8000';
      return url.startsWith('/') ? '$baseUrl$url' : '$baseUrl/$url';
    }
    
    return ApartmentModel(
      id: json['id'] as int,
      address: json['address'] as String? ?? json['address_ar'] as String? ?? 'N/A',
      governorate: json['governorate'] as String?,
      city: json['city'] as String?,
      price: price,
      pricePeriod: pricePeriod,
      status: json['status'] as String? ?? 'inactive',
      averageRating: json['average_rating'] != null
          ? (json['average_rating'] is String
              ? double.tryParse((json['average_rating'] as String).replaceAll(',', ''))
              : (json['average_rating'] as num?)?.toDouble())
          : null,
      totalRatings: json['total_ratings'] as int?,
      totalBookings: json['total_bookings'] as int? ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      ownerId: owner['id'] as int? ?? json['owner_id'] as int? ?? 0,
      ownerName: '${owner['first_name'] ?? ''} ${owner['last_name'] ?? ''}'.trim().isEmpty
          ? 'N/A'
          : '${owner['first_name'] ?? ''} ${owner['last_name'] ?? ''}'.trim(),
      ownerPhoto: convertPhotoUrl(owner['personal_photo'] as String?),
      mainPhoto: convertPhotoUrl(mainPhoto),
      photos: photosList.isNotEmpty
          ? photosList.map((p) => convertPhotoUrl(p as String?)).whereType<String>().toList()
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

