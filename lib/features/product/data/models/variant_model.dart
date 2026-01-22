// Variant Model (for backward compatibility)
import 'product_listing_item.dart';

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

// Variant Details Model (for product details API response)
class VariantDetailsModel {
  final String variantId;
  final String label;
  final Map<String, dynamic>? attributes;
  final ProductPricing pricing;
  final ProductAvailability availability;

  VariantDetailsModel({
    required this.variantId,
    required this.label,
    this.attributes,
    required this.pricing,
    required this.availability,
  });

  factory VariantDetailsModel.fromJson(Map<String, dynamic> json) {
    return VariantDetailsModel(
      variantId: json['variantId'] as String,
      label: json['label'] as String,
      attributes: json['attributes'] as Map<String, dynamic>?,
      pricing: ProductPricing.fromJson(json['pricing'] as Map<String, dynamic>),
      availability: ProductAvailability.fromJson(json['availability'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'variantId': variantId,
      'label': label,
      'attributes': attributes,
      'pricing': pricing.toJson(),
      'availability': availability.toJson(),
    };
  }
}




