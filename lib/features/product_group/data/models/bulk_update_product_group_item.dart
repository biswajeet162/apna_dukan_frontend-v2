// Bulk Update Product Group Item Model
class BulkUpdateProductGroupItem {
  final String productGroupId;
  final String? name;
  final String? description;
  final String? code;
  final int? displayOrder;
  final bool? enabled;
  final List<String>? imageUrl;

  BulkUpdateProductGroupItem({
    required this.productGroupId,
    this.name,
    this.description,
    this.code,
    this.displayOrder,
    this.enabled,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'productGroupId': productGroupId,
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

