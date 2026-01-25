// Get Cart Use Case
import '../../data/repositories/cart_repository.dart';
import '../../data/models/cart_response_model.dart';

class GetCartUseCase {
  final CartRepository _repository;

  GetCartUseCase(this._repository);

  Future<CartResponseModel> call() async {
    return await _repository.getCart();
  }
}

