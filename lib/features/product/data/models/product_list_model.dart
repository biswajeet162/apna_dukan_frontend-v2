// Product List Model
class ProductListModel {
  final String productId;
  final String productGroupId;
  final String name;
  final String? brand;
  final String? description;
  final String code;
  final String? primaryImageUrl;
  final List<String> imageUrls;
  final int displayOrder;
  final bool enabled;

  ProductListModel({
    required this.productId,
    required this.productGroupId,
    required this.name,
    this.brand,
    this.description,
    required this.code,
    this.primaryImageUrl,
    required this.imageUrls,
    required this.displayOrder,
    required this.enabled,
  });

  factory ProductListModel.fromJson(Map<String, dynamic> json) {
    return ProductListModel(
      productId: json['productId'] as String,
      productGroupId: json['productGroupId'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String?,
      description: json['description'] as String?,
      code: json['code'] as String,
      primaryImageUrl: json['primaryImageUrl'] as String?,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((item) => item as String)
              .toList() ??
          [],
      displayOrder: json['displayOrder'] as int,
      enabled: json['enabled'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productGroupId': productGroupId,
      'name': name,
      'brand': brand,
      'description': description,
      'code': code,
      'primaryImageUrl': primaryImageUrl,
      'imageUrls': imageUrls,
      'displayOrder': displayOrder,
      'enabled': enabled,
    };
  }
}




