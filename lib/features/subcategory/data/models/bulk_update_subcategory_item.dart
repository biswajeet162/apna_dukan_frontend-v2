// Bulk Update SubCategory Item Model
class BulkUpdateSubCategoryItem {
  final String subCategoryId;
  final String? name;
  final String? description;
  final String? code;
  final int? displayOrder;
  final bool? enabled;
  final List<String>? imageUrl;

  BulkUpdateSubCategoryItem({
    required this.subCategoryId,
    this.name,
    this.description,
    this.code,
    this.displayOrder,
    this.enabled,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'subCategoryId': subCategoryId,
    };
    if (name != null) json['name'] = name;
    if (description != null) json['description'] = description;
    if (code != null) json['code'] = code!.toUpperCase();
    if (displayOrder != null) json['displayOrder'] = displayOrder;
    if (enabled != null) json['enabled'] = enabled;
    if (imageUrl != null) json['imageUrl'] = imageUrl;
    return json;
  }
}

