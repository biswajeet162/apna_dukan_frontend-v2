// Cart Response Model
class CartResponseModel {
  final List<CartItemModel> items;
  final CartSummaryModel summary;

  CartResponseModel({
    required this.items,
    required this.summary,
  });

  factory CartResponseModel.fromJson(Map<String, dynamic> json) {
    return CartResponseModel(
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      summary: CartSummaryModel.fromJson(json['summary'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'summary': summary.toJson(),
    };
  }
}

class CartItemModel {
  final String variantId;
  final String productName;
  final String variantLabel;
  final int quantity;
  final PriceModel price;
  final AvailabilityModel availability;

  CartItemModel({
    required this.variantId,
    required this.productName,
    required this.variantLabel,
    required this.quantity,
    required this.price,
    required this.availability,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      variantId: json['variantId'] as String,
      productName: json['productName'] as String,
      variantLabel: json['variantLabel'] as String,
      quantity: json['quantity'] as int,
      price: PriceModel.fromJson(json['price'] as Map<String, dynamic>),
      availability: AvailabilityModel.fromJson(json['availability'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'variantId': variantId,
      'productName': productName,
      'variantLabel': variantLabel,
      'quantity': quantity,
      'price': price.toJson(),
      'availability': availability.toJson(),
    };
  }
}

class PriceModel {
  final double sellingPrice;
  final double mrp;
  final int discountPercent;
  final String currency;

  PriceModel({
    required this.sellingPrice,
    required this.mrp,
    required this.discountPercent,
    required this.currency,
  });

  factory PriceModel.fromJson(Map<String, dynamic> json) {
    return PriceModel(
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

class AvailabilityModel {
  final bool inStock;

  AvailabilityModel({
    required this.inStock,
  });

  factory AvailabilityModel.fromJson(Map<String, dynamic> json) {
    return AvailabilityModel(
      inStock: json['inStock'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'inStock': inStock,
    };
  }
}

class CartSummaryModel {
  final int totalItems;
  final double subtotal;

  CartSummaryModel({
    required this.totalItems,
    required this.subtotal,
  });

  factory CartSummaryModel.fromJson(Map<String, dynamic> json) {
    return CartSummaryModel(
      totalItems: json['totalItems'] as int,
      subtotal: (json['subtotal'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalItems': totalItems,
      'subtotal': subtotal,
    };
  }
}

