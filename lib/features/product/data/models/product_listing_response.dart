// Product Listing Response Model
import 'product_listing_item.dart';

class ProductListingResponse {
  final String productGroupId;
  final String productGroupName;
  final List<ProductListingItem> products;
  final PaginationMetadata pagination;

  ProductListingResponse({
    required this.productGroupId,
    required this.productGroupName,
    required this.products,
    required this.pagination,
  });

  factory ProductListingResponse.fromJson(Map<String, dynamic> json) {
    return ProductListingResponse(
      productGroupId: json['productGroupId'] as String,
      productGroupName: json['productGroupName'] as String,
      products: (json['products'] as List<dynamic>?)
              ?.map((item) => ProductListingItem.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: PaginationMetadata.fromJson(
          json['pagination'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productGroupId': productGroupId,
      'productGroupName': productGroupName,
      'products': products.map((p) => p.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class PaginationMetadata {
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  PaginationMetadata({
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory PaginationMetadata.fromJson(Map<String, dynamic> json) {
    return PaginationMetadata(
      page: json['page'] as int,
      size: json['size'] as int,
      totalElements: json['totalElements'] as int,
      totalPages: json['totalPages'] as int,
      hasNext: json['hasNext'] as bool,
      hasPrevious: json['hasPrevious'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'size': size,
      'totalElements': totalElements,
      'totalPages': totalPages,
      'hasNext': hasNext,
      'hasPrevious': hasPrevious,
    };
  }
}

