// Create Product Group Request Model
class CreateProductGroupRequest {
  final String subCategoryId;
  final String name;
  final String? description;
  final String code;
  final int displayOrder;
  final bool enabled;
  final List<String> imageUrl;

  CreateProductGroupRequest({
    required this.subCategoryId,
    required this.name,
    this.description,
    required this.code,
    required this.displayOrder,
    this.enabled = true,
    this.imageUrl = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'subCategoryId': subCategoryId,
      'name': name,
      if (description != null && description!.isNotEmpty) 'description': description,
      'code': code.toUpperCase(),
      'displayOrder': displayOrder,
      'enabled': enabled,
      if (imageUrl.isNotEmpty) 'imageUrl': imageUrl,
    };
  }
}

