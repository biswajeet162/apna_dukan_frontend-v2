// Category Model
class CategoryModel {
  final String categoryId;
  final String sectionId;
  final String name;
  final String? description;
  final String code;
  final int displayOrder;
  final bool enabled;

  CategoryModel({
    required this.categoryId,
    required this.sectionId,
    required this.name,
    this.description,
    required this.code,
    required this.displayOrder,
    required this.enabled,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json['categoryId'] as String,
      sectionId: json['sectionId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      code: json['code'] as String,
      displayOrder: json['displayOrder'] as int,
      enabled: json['enabled'] as bool,
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
    };
  }
}


