// Product Details Controller
import 'package:flutter/material.dart';
import '../../data/models/product_details_model.dart';
import '../../data/models/variant_model.dart';
import '../../data/repositories/product_repository.dart';

class ProductDetailsController extends ChangeNotifier {
  final ProductRepository _repository;

  ProductDetailsController(this._repository);

  ProductDetailsModel? _product;
  VariantModel? _selectedVariant;
  bool _isLoading = false;
  String? _errorMessage;

  ProductDetailsModel? get product => _product;
  VariantModel? get selectedVariant => _selectedVariant;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadProductDetails(String productId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _product = await _repository.getProductDetails(productId);
      if (_product != null && _product!.variants.isNotEmpty) {
        _selectedVariant = _product!.variants.firstWhere(
          (v) => v.isDefault,
          orElse: () => _product!.variants.first,
        );
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void selectVariant(VariantModel variant) {
    _selectedVariant = variant;
    notifyListeners();
  }
}

