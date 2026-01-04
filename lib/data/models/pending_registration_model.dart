import '../../domain/entities/pending_registration.dart';

class PendingRegistrationModel extends PendingRegistration {
  const PendingRegistrationModel({
    required super.id,
    required super.mobileNumber,
    required super.firstName,
    required super.lastName,
    super.personalPhoto,
    super.idPhoto,
    required super.role,
    required super.status,
    required super.createdAt,
  });

  factory PendingRegistrationModel.fromJson(Map<String, dynamic> json) {
    return PendingRegistrationModel(
      id: json['id'] as int,
      mobileNumber: json['mobile_number'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      personalPhoto: json['personal_photo'] as String?,
      idPhoto: json['id_photo'] as String?,
      role: json['role'] as String,
      status: json['status'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mobile_number': mobileNumber,
      'first_name': firstName,
      'last_name': lastName,
      'personal_photo': personalPhoto,
      'id_photo': idPhoto,
      'role': role,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

