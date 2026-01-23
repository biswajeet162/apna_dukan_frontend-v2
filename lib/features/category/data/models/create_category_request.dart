// Create Category Request Model
class CreateCategoryRequest {
  final String sectionId;
  final String name;
  final String? description;
  final String code;
  final int displayOrder;
  final bool enabled;

  CreateCategoryRequest({
    required this.sectionId,
    required this.name,
    this.description,
    required this.code,
    required this.displayOrder,
    this.enabled = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'sectionId': sectionId,
      'name': name,
      if (description != null && description!.isNotEmpty) 'description': description,
      'code': code.toUpperCase(), // Ensure uppercase
      'displayOrder': displayOrder,
      'enabled': enabled,
    };
  }
}

