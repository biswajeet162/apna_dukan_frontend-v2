// Product Group Model
class ProductGroupModel {
  final String productGroupId;
  final String subCategoryId;
  final String name;
  final String? description;
  final String code;
  final int displayOrder;
  final bool enabled;
  final List<String> imageUrl;

  ProductGroupModel({
    required this.productGroupId,
    required this.subCategoryId,
    required this.name,
    this.description,
    required this.code,
    required this.displayOrder,
    required this.enabled,
    required this.imageUrl,
  });

  factory ProductGroupModel.fromJson(Map<String, dynamic> json) {
    return ProductGroupModel(
      productGroupId: json['productGroupId'] as String,
      subCategoryId: json['subCategoryId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      code: json['code'] as String,
      displayOrder: json['displayOrder'] as int,
      enabled: json['enabled'] as bool,
      imageUrl: (json['imageUrl'] as List<dynamic>?)
              ?.map((item) => item as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productGroupId': productGroupId,
      'subCategoryId': subCategoryId,
      'name': name,
      'description': description,
      'code': code,
      'displayOrder': displayOrder,
      'enabled': enabled,
      'imageUrl': imageUrl,
    };
  }
}



