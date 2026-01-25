// Remove Cart Item Use Case
import '../../data/repositories/cart_repository.dart';

class RemoveCartItemUseCase {
  final CartRepository _repository;

  RemoveCartItemUseCase(this._repository);

  Future<void> call(String variantId) async {
    return await _repository.removeCartItem(variantId);
  }
}

