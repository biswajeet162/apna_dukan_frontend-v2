// Product Repository
import '../models/product_list_model.dart';
import '../models/product_details_model.dart';

class ProductRepository {
  // TODO: Add remote data source
  // final ProductRemoteDataSource _remoteDataSource;

  // ProductRepository(this._remoteDataSource);

  Future<List<ProductListModel>> getProductsForProductGroup(String productGroupId) async {
    // TODO: Implement API call
    throw UnimplementedError('Not implemented yet');
  }

  Future<ProductDetailsModel> getProductDetails(String productId) async {
    // TODO: Implement API call
    throw UnimplementedError('Not implemented yet');
  }
}

