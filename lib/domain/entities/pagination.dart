import 'package:equatable/equatable.dart';

class Pagination extends Equatable {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int perPage;

  const Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.perPage,
  });

  bool get hasNextPage => currentPage < totalPages;
  bool get hasPreviousPage => currentPage > 1;

  @override
  List<Object?> get props => [currentPage, totalPages, totalItems, perPage];
}

