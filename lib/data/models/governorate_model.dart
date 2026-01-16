import '../../domain/entities/governorate.dart';

class GovernorateModel extends Governorate {
  const GovernorateModel({
    required super.name,
    super.nameAr,
  });

  factory GovernorateModel.fromJson(Map<String, dynamic> json) {
    return GovernorateModel(
      name: json['name'] as String,
      nameAr: json['name_ar'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (nameAr != null) 'name_ar': nameAr,
    };
  }
}

