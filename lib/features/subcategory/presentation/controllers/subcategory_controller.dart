// SubCategory Controller
import 'package:flutter/material.dart';
import '../../data/models/subcategory_response.dart';
import '../../data/repositories/subcategory_repository.dart';

class SubCategoryController extends ChangeNotifier {
  final SubCategoryRepository _repository;

  SubCategoryController(this._repository);

  SubCategoryResponse? _subCategoryResponse;
  bool _isLoading = false;
  String? _errorMessage;

  SubCategoryResponse? get subCategoryResponse => _subCategoryResponse;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadSubCategoriesForCategory(String categoryId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _subCategoryResponse = await _repository.getSubCategoriesForCategory(categoryId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}



