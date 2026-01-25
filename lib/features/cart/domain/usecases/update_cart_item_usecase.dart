// Update Cart Item Use Case
import '../../data/repositories/cart_repository.dart';
import '../../data/models/update_cart_item_request.dart';

class UpdateCartItemUseCase {
  final CartRepository _repository;

  UpdateCartItemUseCase(this._repository);

  Future<void> call(String variantId, UpdateCartItemRequest request) async {
    return await _repository.updateCartItem(variantId, request);
  }
}

