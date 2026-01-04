import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String mobileNumber;
  final String firstName;
  final String lastName;
  final String personalPhoto;
  final DateTime? dateOfBirth;
  final String? idPhoto;
  final String role; // 'tenant', 'owner', 'admin'
  final String status; // 'pending', 'approved', 'rejected'
  final String languagePreference; // 'en', 'ar'
  final double balance;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.mobileNumber,
    required this.firstName,
    required this.lastName,
    required this.personalPhoto,
    this.dateOfBirth,
    this.idPhoto,
    required this.role,
    required this.status,
    this.languagePreference = 'en',
    this.balance = 0.0,
    required this.createdAt,
  });

  String get fullName => '$firstName $lastName';
  
  bool get isApproved => status == 'approved';
  bool get isPending => status == 'pending';
  bool get isRejected => status == 'rejected';
  bool get isAdmin => role == 'admin';
  bool get isOwner => role == 'owner';
  bool get isTenant => role == 'tenant';

  @override
  List<Object?> get props => [
        id,
        mobileNumber,
        firstName,
        lastName,
        personalPhoto,
        dateOfBirth,
        idPhoto,
        role,
        status,
        languagePreference,
        balance,
        createdAt,
      ];
}

