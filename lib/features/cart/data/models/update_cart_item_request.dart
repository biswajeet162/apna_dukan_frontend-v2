// Update Cart Item Request Model
class UpdateCartItemRequest {
  final int quantity;

  UpdateCartItemRequest({
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
    };
  }
}

