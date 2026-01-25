// Add Cart Item Use Case
import '../../data/repositories/cart_repository.dart';
import '../../data/models/add_cart_item_request.dart';

class AddCartItemUseCase {
  final CartRepository _repository;

  AddCartItemUseCase(this._repository);

  Future<void> call(AddCartItemRequest request) async {
    return await _repository.addCartItem(request);
  }
}

