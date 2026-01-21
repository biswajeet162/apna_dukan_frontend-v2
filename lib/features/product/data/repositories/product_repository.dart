// Product Repository
import '../models/product_list_model.dart';
import '../models/product_details_model.dart';
import '../models/product_listing_response.dart';
import '../datasources/product_listing_remote_datasource.dart';

class ProductRepository {
  final ProductListingRemoteDataSource _remoteDataSource;

  ProductRepository(this._remoteDataSource);

  Future<ProductListingResponse> getProductListing(
    String productGroupId, {
    int page = 0,
    int size = 100,
  }) async {
    return await _remoteDataSource.getProductListing(
      productGroupId,
      page: page,
      size: size,
    );
  }

  Future<List<ProductListModel>> getProductsForProductGroup(String productGroupId) async {
    // TODO: Implement API call
    throw UnimplementedError('Not implemented yet');
  }

  Future<ProductDetailsModel> getProductDetails(String productId) async {
    // TODO: Implement API call
    throw UnimplementedError('Not implemented yet');
  }
}



