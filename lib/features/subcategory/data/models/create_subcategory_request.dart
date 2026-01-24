// Create SubCategory Request Model
class CreateSubCategoryRequest {
  final String categoryId;
  final String name;
  final String? description;
  final String code;
  final int displayOrder;
  final bool enabled;
  final List<String> imageUrl;

  CreateSubCategoryRequest({
    required this.categoryId,
    required this.name,
    this.description,
    required this.code,
    required this.displayOrder,
    this.enabled = true,
    this.imageUrl = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'name': name,
      if (description != null && description!.isNotEmpty) 'description': description,
      'code': code.toUpperCase(), // Ensure uppercase
      'displayOrder': displayOrder,
      'enabled': enabled,
      if (imageUrl.isNotEmpty) 'imageUrl': imageUrl,
    };
  }
}

