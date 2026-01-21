// Product Listing Item Model
class ProductListingItem {
  final String productId;
  final String name;
  final String? brand;
  final ProductImage image;
  final DefaultVariant defaultVariant;
  final ProductPricing pricing;
  final ProductAvailability availability;
  final ProductMetrics? metrics;

  ProductListingItem({
    required this.productId,
    required this.name,
    this.brand,
    required this.image,
    required this.defaultVariant,
    required this.pricing,
    required this.availability,
    this.metrics,
  });

  factory ProductListingItem.fromJson(Map<String, dynamic> json) {
    return ProductListingItem(
      productId: json['productId'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String?,
      image: ProductImage.fromJson(json['image'] as Map<String, dynamic>),
      defaultVariant: DefaultVariant.fromJson(
          json['defaultVariant'] as Map<String, dynamic>),
      pricing: ProductPricing.fromJson(json['pricing'] as Map<String, dynamic>),
      availability: ProductAvailability.fromJson(
          json['availability'] as Map<String, dynamic>),
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
      'image': image.toJson(),
      'defaultVariant': defaultVariant.toJson(),
      'pricing': pricing.toJson(),
      'availability': availability.toJson(),
      'metrics': metrics?.toJson(),
    };
  }
}

class ProductImage {
  final String? primary;
  final List<String> gallery;

  ProductImage({
    this.primary,
    required this.gallery,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      primary: json['primary'] as String?,
      gallery: (json['gallery'] as List<dynamic>?)
              ?.map((item) => item as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'primary': primary,
      'gallery': gallery,
    };
  }
}

class DefaultVariant {
  final String variantId;
  final String label;

  DefaultVariant({
    required this.variantId,
    required this.label,
  });

  factory DefaultVariant.fromJson(Map<String, dynamic> json) {
    return DefaultVariant(
      variantId: json['variantId'] as String,
      label: json['label'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'variantId': variantId,
      'label': label,
    };
  }
}

class ProductPricing {
  final double sellingPrice;
  final double mrp;
  final int discountPercent;
  final String currency;

  ProductPricing({
    required this.sellingPrice,
    required this.mrp,
    required this.discountPercent,
    required this.currency,
  });

  factory ProductPricing.fromJson(Map<String, dynamic> json) {
    return ProductPricing(
      sellingPrice: (json['sellingPrice'] as num).toDouble(),
      mrp: (json['mrp'] as num).toDouble(),
      discountPercent: json['discountPercent'] as int,
      currency: json['currency'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sellingPrice': sellingPrice,
      'mrp': mrp,
      'discountPercent': discountPercent,
      'currency': currency,
    };
  }
}

class ProductAvailability {
  final bool inStock;
  final int availableQuantity;

  ProductAvailability({
    required this.inStock,
    required this.availableQuantity,
  });

  factory ProductAvailability.fromJson(Map<String, dynamic> json) {
    return ProductAvailability(
      inStock: json['inStock'] as bool,
      availableQuantity: json['availableQuantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'inStock': inStock,
      'availableQuantity': availableQuantity,
    };
  }
}

class ProductMetrics {
  final ProductRating? rating;
  final ProductPopularity? popularity;

  ProductMetrics({
    this.rating,
    this.popularity,
  });

  factory ProductMetrics.fromJson(Map<String, dynamic> json) {
    return ProductMetrics(
      rating: json['rating'] != null
          ? ProductRating.fromJson(json['rating'] as Map<String, dynamic>)
          : null,
      popularity: json['popularity'] != null
          ? ProductPopularity.fromJson(json['popularity'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rating': rating?.toJson(),
      'popularity': popularity?.toJson(),
    };
  }
}

class ProductRating {
  final double average;
  final int count;

  ProductRating({
    required this.average,
    required this.count,
  });

  factory ProductRating.fromJson(Map<String, dynamic> json) {
    return ProductRating(
      average: (json['average'] as num).toDouble(),
      count: json['count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'average': average,
      'count': count,
    };
  }
}

class ProductPopularity {
  final int totalPurchased;

  ProductPopularity({
    required this.totalPurchased,
  });

  factory ProductPopularity.fromJson(Map<String, dynamic> json) {
    return ProductPopularity(
      totalPurchased: json['totalPurchased'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalPurchased': totalPurchased,
    };
  }
}

