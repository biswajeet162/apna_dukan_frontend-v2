// Pagination Model
class PaginationModel<T> {
  final List<T> items;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final bool hasNext;
  final bool hasPrevious;

  PaginationModel({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory PaginationModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginationModel(
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => fromJsonT(item as Map<String, dynamic>))
              .toList() ??
          [],
      currentPage: json['currentPage'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 0,
      totalItems: json['totalItems'] as int? ?? 0,
      hasNext: json['hasNext'] as bool? ?? false,
      hasPrevious: json['hasPrevious'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'items': items.map((item) => toJsonT(item)).toList(),
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalItems': totalItems,
      'hasNext': hasNext,
      'hasPrevious': hasPrevious,
    };
  }
}




