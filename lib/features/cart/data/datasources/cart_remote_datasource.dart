// Cart Remote Data Source
import 'package:dio/dio.dart';
import '../models/cart_response_model.dart';
import '../models/add_cart_item_request.dart';
import '../models/update_cart_item_request.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_endpoints.dart';

class CartRemoteDataSource {
  final DioClient _dioClient;

  CartRemoteDataSource(this._dioClient);

  // GET /api/cart
  Future<CartResponseModel> getCart() async {
    try {
      final response = await _dioClient.dio.get(ApiEndpoints.cart);

      if (response.statusCode == 200) {
        return CartResponseModel.fromJson(
            response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load cart');
      }
    } on DioException catch (e) {
      throw Exception('Error fetching cart: ${e.message}');
    }
  }

  // POST /api/cart/items
  Future<void> addCartItem(AddCartItemRequest request) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.cartItems,
        data: request.toJson(),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add item to cart');
      }
    } on DioException catch (e) {
      throw Exception('Error adding item to cart: ${e.message}');
    }
  }

  // PUT /api/cart/items/{variantId}
  Future<void> updateCartItem(String variantId, UpdateCartItemRequest request) async {
    try {
      final response = await _dioClient.dio.put(
        ApiEndpoints.cartItemByVariantId(variantId),
        data: request.toJson(),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update cart item');
      }
    } on DioException catch (e) {
      throw Exception('Error updating cart item: ${e.message}');
    }
  }

  // DELETE /api/cart/items/{variantId}
  Future<void> removeCartItem(String variantId) async {
    try {
      final response = await _dioClient.dio.delete(
        ApiEndpoints.cartItemByVariantId(variantId),
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to remove cart item');
      }
    } on DioException catch (e) {
      throw Exception('Error removing cart item: ${e.message}');
    }
  }
}

