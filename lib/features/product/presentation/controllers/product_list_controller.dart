// Product List Controller
import 'package:flutter/material.dart';
import '../../data/models/product_list_model.dart';
import '../../data/repositories/product_repository.dart';

class ProductListController extends ChangeNotifier {
  final ProductRepository _repository;

  ProductListController(this._repository);

  List<ProductListModel> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ProductListModel> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadProductsForProductGroup(String productGroupId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _products = await _repository.getProductsForProductGroup(productGroupId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}


