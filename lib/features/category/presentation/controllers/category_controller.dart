// Category Controller
import 'package:flutter/material.dart';
import '../../data/models/category_section_response.dart';
import '../../data/repositories/category_repository.dart';

class CategoryController extends ChangeNotifier {
  final CategoryRepository _repository;

  CategoryController(this._repository);

  CategorySectionResponse? _categorySectionResponse;
  bool _isLoading = false;
  String? _errorMessage;

  CategorySectionResponse? get categorySectionResponse => _categorySectionResponse;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadCategoriesForSection(String sectionId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _categorySectionResponse = await _repository.getCategoriesForSection(sectionId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}



