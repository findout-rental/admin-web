import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.mobileNumber,
    required super.firstName,
    required super.lastName,
    required super.personalPhoto,
    super.dateOfBirth,
    super.idPhoto,
    required super.role,
    required super.status,
    super.languagePreference,
    super.balance,
    required super.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      mobileNumber: json['mobile_number'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      personalPhoto: json['personal_photo'] as String? ?? '',
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'] as String)
          : null,
      idPhoto: json['id_photo'] as String?,
      role: json['role'] as String,
      status: json['status'] as String,
      languagePreference: json['language_preference'] as String? ?? 'en',
      balance: json['balance'] != null
          ? (json['balance'] is String
              ? double.tryParse(json['balance'] as String) ?? 0.0
              : (json['balance'] as num).toDouble())
          : 0.0,
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
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'id_photo': idPhoto,
      'role': role,
      'status': status,
      'language_preference': languagePreference,
      'balance': balance,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
