// Variant Model
class VariantModel {
  final String variantId;
  final String productId;
  final String? sku;
  final String? name;
  final Map<String, dynamic>? attributes;
  final bool isDefault;
  final bool enabled;

  VariantModel({
    required this.variantId,
    required this.productId,
    this.sku,
    this.name,
    this.attributes,
    required this.isDefault,
    required this.enabled,
  });

  factory VariantModel.fromJson(Map<String, dynamic> json) {
    return VariantModel(
      variantId: json['variantId'] as String,
      productId: json['productId'] as String,
      sku: json['sku'] as String?,
      name: json['name'] as String?,
      attributes: json['attributes'] as Map<String, dynamic>?,
      isDefault: json['isDefault'] as bool? ?? false,
      enabled: json['enabled'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'variantId': variantId,
      'productId': productId,
      'sku': sku,
      'name': name,
      'attributes': attributes,
      'isDefault': isDefault,
      'enabled': enabled,
    };
  }
}



