// Product Group Admin Model (with timestamps)
class ProductGroupAdminModel {
  final String productGroupId;
  final String subCategoryId;
  final String name;
  final String? description;
  final String code;
  final int displayOrder;
  final bool enabled;
  final List<String> imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductGroupAdminModel({
    required this.productGroupId,
    required this.subCategoryId,
    required this.name,
    this.description,
    required this.code,
    required this.displayOrder,
    required this.enabled,
    required this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductGroupAdminModel.fromJson(Map<String, dynamic> json) {
    return ProductGroupAdminModel(
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
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
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
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

