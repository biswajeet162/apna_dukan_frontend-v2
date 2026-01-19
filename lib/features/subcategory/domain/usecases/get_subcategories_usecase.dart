// Get SubCategories Use Case
import '../models/subcategory_response.dart';
import '../repositories/subcategory_repository_interface.dart';

class GetSubCategoriesUseCase {
  final SubCategoryRepositoryInterface _repository;

  GetSubCategoriesUseCase(this._repository);

  Future<SubCategoryResponse> call(String categoryId) async {
    return await _repository.getSubCategoriesForCategory(categoryId);
  }
}


