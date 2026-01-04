import 'package:equatable/equatable.dart';

class PendingRegistration extends Equatable {
  final int id;
  final String mobileNumber;
  final String firstName;
  final String lastName;
  final String? personalPhoto;
  final String? idPhoto;
  final String role; // 'tenant' or 'owner'
  final String status; // 'pending'
  final DateTime createdAt;

  const PendingRegistration({
    required this.id,
    required this.mobileNumber,
    required this.firstName,
    required this.lastName,
    this.personalPhoto,
    this.idPhoto,
    required this.role,
    required this.status,
    required this.createdAt,
  });

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [
        id,
        mobileNumber,
        firstName,
        lastName,
        personalPhoto,
        idPhoto,
        role,
        status,
        createdAt,
      ];
}

