// Category Admin Model (with timestamps)
class CategoryAdminModel {
  final String categoryId;
  final String sectionId;
  final String name;
  final String? description;
  final String code;
  final int displayOrder;
  final bool enabled;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CategoryAdminModel({
    required this.categoryId,
    required this.sectionId,
    required this.name,
    this.description,
    required this.code,
    required this.displayOrder,
    required this.enabled,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryAdminModel.fromJson(Map<String, dynamic> json) {
    return CategoryAdminModel(
      categoryId: json['categoryId'] as String,
      sectionId: json['sectionId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      code: json['code'] as String,
      displayOrder: json['displayOrder'] as int,
      enabled: json['enabled'] as bool,
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
      'categoryId': categoryId,
      'sectionId': sectionId,
      'name': name,
      'description': description,
      'code': code,
      'displayOrder': displayOrder,
      'enabled': enabled,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

