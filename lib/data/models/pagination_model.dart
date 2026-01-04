import '../../domain/entities/pagination.dart';

class PaginationModel extends Pagination {
  const PaginationModel({
    required super.currentPage,
    required super.totalPages,
    required super.totalItems,
    required super.perPage,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: json['current_page'] as int? ?? 1,
      totalPages: json['total_pages'] as int? ?? 1,
      totalItems: json['total_items'] as int? ?? 0,
      perPage: json['per_page'] as int? ?? 20,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'total_pages': totalPages,
      'total_items': totalItems,
      'per_page': perPage,
    };
  }
}

