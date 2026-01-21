// Product Group Controller
import 'package:flutter/material.dart';
import '../../data/models/product_group_model.dart';
import '../../data/models/product_group_response.dart';
import '../../data/repositories/product_group_repository.dart';

class ProductGroupController extends ChangeNotifier {
  final ProductGroupRepository _repository;

  ProductGroupController(this._repository);

  List<ProductGroupModel> _productGroups = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ProductGroupModel> get productGroups => _productGroups;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadProductGroupsForSubCategory(String subCategoryId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _repository.getProductGroupsForSubCategory(subCategoryId);
      _productGroups = response.productGroups;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}



