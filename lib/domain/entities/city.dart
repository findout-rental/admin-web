import 'package:equatable/equatable.dart';

class City extends Equatable {
  final String name;
  final String? nameAr;
  final String governorate;

  const City({
    required this.name,
    this.nameAr,
    required this.governorate,
  });

  @override
  List<Object?> get props => [name, nameAr, governorate];
}

