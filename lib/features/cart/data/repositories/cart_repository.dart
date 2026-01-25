// Cart Repository
import '../datasources/cart_remote_datasource.dart';
import '../models/cart_response_model.dart';
import '../models/add_cart_item_request.dart';
import '../models/update_cart_item_request.dart';

class CartRepository {
  final CartRemoteDataSource _remoteDataSource;

  CartRepository(this._remoteDataSource);

  Future<CartResponseModel> getCart() async {
    return await _remoteDataSource.getCart();
  }

  Future<void> addCartItem(AddCartItemRequest request) async {
    return await _remoteDataSource.addCartItem(request);
  }

  Future<void> updateCartItem(String variantId, UpdateCartItemRequest request) async {
    return await _remoteDataSource.updateCartItem(variantId, request);
  }

  Future<void> removeCartItem(String variantId) async {
    return await _remoteDataSource.removeCartItem(variantId);
  }
}

