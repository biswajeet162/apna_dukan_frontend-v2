// Product Details Model
import 'variant_model.dart';
import 'product_listing_item.dart';

class ProductDetailsModel {
  final String productId;
  final String name;
  final String? brand;
  final String? description;
  final ProductImage images;
  final List<VariantDetailsModel> variants;
  final ProductMetrics? metrics;

  ProductDetailsModel({
    required this.productId,
    required this.name,
    this.brand,
    this.description,
    required this.images,
    required this.variants,
    this.metrics,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsModel(
      productId: json['productId'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String?,
      description: json['description'] as String?,
      images: ProductImage.fromJson(json['images'] as Map<String, dynamic>),
      variants: (json['variants'] as List<dynamic>?)
              ?.map((item) => VariantDetailsModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      metrics: json['metrics'] != null
          ? ProductMetrics.fromJson(json['metrics'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'brand': brand,
      'description': description,
      'images': images.toJson(),
      'variants': variants.map((v) => v.toJson()).toList(),
      'metrics': metrics?.toJson(),
    };
  }
}




