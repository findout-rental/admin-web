import '../../domain/entities/city.dart';

class CityModel extends City {
  const CityModel({
    required super.name,
    super.nameAr,
    required super.governorate,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      name: json['name'] as String,
      nameAr: json['name_ar'] as String?,
      governorate: json['governorate'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (nameAr != null) 'name_ar': nameAr,
      'governorate': governorate,
    };
  }
}

