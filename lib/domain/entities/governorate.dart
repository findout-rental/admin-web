import 'package:equatable/equatable.dart';

class Governorate extends Equatable {
  final String name;
  final String? nameAr;

  const Governorate({
    required this.name,
    this.nameAr,
  });

  @override
  List<Object?> get props => [name, nameAr];
}

