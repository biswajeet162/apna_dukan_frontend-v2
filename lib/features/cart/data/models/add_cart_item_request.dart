// Add Cart Item Request Model
class AddCartItemRequest {
  final String variantId;
  final int quantity;

  AddCartItemRequest({
    required this.variantId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'variantId': variantId,
      'quantity': quantity,
    };
  }
}

