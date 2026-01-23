// Get Category By ID Use Case
import '../../data/models/category_admin_model.dart';
import '../repositories/category_repository_interface.dart';

class GetCategoryByIdUseCase {
  final CategoryRepositoryInterface _repository;

  GetCategoryByIdUseCase(this._repository);

  Future<CategoryAdminModel> call(String categoryId) async {
    return await _repository.getCategoryById(categoryId);
  }
}

