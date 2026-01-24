// SubCategory Admin Model (with timestamps)
class SubCategoryAdminModel {
  final String subCategoryId;
  final String categoryId;
  final String name;
  final String? description;
  final String code;
  final int displayOrder;
  final bool enabled;
  final List<String> imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SubCategoryAdminModel({
    required this.subCategoryId,
    required this.categoryId,
    required this.name,
    this.description,
    required this.code,
    required this.displayOrder,
    required this.enabled,
    required this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory SubCategoryAdminModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryAdminModel(
      subCategoryId: json['subCategoryId'] as String,
      categoryId: json['categoryId'] as String,
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
      'subCategoryId': subCategoryId,
      'categoryId': categoryId,
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

