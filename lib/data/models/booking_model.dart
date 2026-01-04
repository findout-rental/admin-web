import '../../domain/entities/booking.dart';

class BookingModel extends Booking {
  const BookingModel({
    required super.id,
    required super.tenantId,
    required super.tenantName,
    super.tenantPhoto,
    required super.apartmentId,
    required super.apartmentAddress,
    required super.ownerId,
    required super.ownerName,
    super.ownerPhoto,
    required super.checkInDate,
    required super.checkOutDate,
    required super.duration,
    required super.totalPrice,
    required super.status,
    required super.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    final tenant = json['tenant'] as Map<String, dynamic>? ?? {};
    final apartment = json['apartment'] as Map<String, dynamic>? ?? {};
    final owner = json['owner'] as Map<String, dynamic>? ?? apartment['owner'] as Map<String, dynamic>? ?? {};
    
    return BookingModel(
      id: json['id'] as int,
      tenantId: tenant['id'] as int? ?? json['tenant_id'] as int? ?? 0,
      tenantName: tenant['name'] as String? ??
          '${tenant['first_name'] ?? ''} ${tenant['last_name'] ?? ''}'.trim(),
      tenantPhoto: tenant['personal_photo'] as String?,
      apartmentId: apartment['id'] as int? ?? json['apartment_id'] as int? ?? 0,
      apartmentAddress: apartment['address'] as String? ?? json['apartment_address'] as String? ?? 'N/A',
      ownerId: owner['id'] as int? ?? json['owner_id'] as int? ?? 0,
      ownerName: owner['name'] as String? ??
          '${owner['first_name'] ?? ''} ${owner['last_name'] ?? ''}'.trim(),
      ownerPhoto: owner['personal_photo'] as String?,
      checkInDate: json['check_in_date'] != null
          ? DateTime.parse(json['check_in_date'] as String)
          : DateTime.now(),
      checkOutDate: json['check_out_date'] != null
          ? DateTime.parse(json['check_out_date'] as String)
          : DateTime.now(),
      duration: json['duration'] as int? ?? 0,
      totalPrice: json['total_price'] != null
          ? (json['total_price'] is String
              ? double.tryParse(json['total_price'] as String) ?? 0.0
              : (json['total_price'] as num).toDouble())
          : 0.0,
      status: json['status'] as String? ?? 'pending',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenant_id': tenantId,
      'tenant': {
        'id': tenantId,
        'name': tenantName,
        'personal_photo': tenantPhoto,
      },
      'apartment_id': apartmentId,
      'apartment': {
        'id': apartmentId,
        'address': apartmentAddress,
        'owner': {
          'id': ownerId,
          'name': ownerName,
          'personal_photo': ownerPhoto,
        },
      },
      'check_in_date': checkInDate.toIso8601String(),
      'check_out_date': checkOutDate.toIso8601String(),
      'duration': duration,
      'total_price': totalPrice,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

