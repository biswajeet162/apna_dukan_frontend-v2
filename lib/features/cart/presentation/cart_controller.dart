// Cart Controller (State Management)
import 'package:flutter/foundation.dart';
import '../data/models/cart_response_model.dart';
import '../domain/usecases/get_cart_usecase.dart';
import '../domain/usecases/add_cart_item_usecase.dart';
import '../domain/usecases/update_cart_item_usecase.dart';
import '../domain/usecases/remove_cart_item_usecase.dart';
import '../data/models/add_cart_item_request.dart';
import '../data/models/update_cart_item_request.dart';

class CartController extends ChangeNotifier implements ValueListenable<int> {
  final GetCartUseCase _getCartUseCase;
  final AddCartItemUseCase _addCartItemUseCase;
  final UpdateCartItemUseCase _updateCartItemUseCase;
  final RemoveCartItemUseCase _removeCartItemUseCase;

  CartController(
    this._getCartUseCase,
    this._addCartItemUseCase,
    this._updateCartItemUseCase,
    this._removeCartItemUseCase,
  );

  CartResponseModel? _cart;
  bool _isLoading = false;
  String? _errorMessage;

  CartResponseModel? get cart => _cart;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  // Get total items count
  int get totalItems => _cart?.summary.totalItems ?? 0;
  
  // Check if cart has items
  bool get hasItems => totalItems > 0;
  
  // ValueListenable implementation
  @override
  int get value => totalItems;

  // Load cart
  Future<void> loadCart() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _cart = await _getCartUseCase.call();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Add item to cart
  Future<void> addItem(String variantId, int quantity) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final request = AddCartItemRequest(
        variantId: variantId,
        quantity: quantity,
      );
      
      await _addCartItemUseCase.call(request);
      
      // Reload cart to get updated data
      await loadCart();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Update cart item
  Future<void> updateItem(String variantId, int quantity) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final request = UpdateCartItemRequest(quantity: quantity);
      await _updateCartItemUseCase.call(variantId, request);
      
      // Reload cart to get updated data
      await loadCart();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Remove cart item
  Future<void> removeItem(String variantId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _removeCartItemUseCase.call(variantId);
      
      // Reload cart to get updated data
      await loadCart();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Clear cart data (e.g., on logout)
  void clearCart() {
    _cart = null;
    _errorMessage = null;
    notifyListeners();
  }
}
