// Get Product Listing Use Case
import '../../data/models/product_listing_response.dart';
import '../../data/repositories/product_repository.dart';

class GetProductListingUseCase {
  final ProductRepository _repository;

  GetProductListingUseCase(this._repository);

  Future<ProductListingResponse> call(
    String productGroupId, {
    int page = 0,
    int size = 100,
  }) async {
    return await _repository.getProductListing(
      productGroupId,
      page: page,
      size: size,
    );
  }
}


