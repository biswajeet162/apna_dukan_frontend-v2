// Get Product Details Use Case
import '../../data/models/product_details_model.dart';
import '../../data/repositories/product_repository.dart';

class GetProductDetailsUseCase {
  final ProductRepository _repository;

  GetProductDetailsUseCase(this._repository);

  // API CALL: Product Details API (/v1/product/{productId})
  Future<ProductDetailsModel> call(String productId) async {
    return await _repository.getProductDetails(productId);
  }
}

