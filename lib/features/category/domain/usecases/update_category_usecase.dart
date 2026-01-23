// Update Category Use Case
import '../../data/models/category_admin_model.dart';
import '../repositories/category_repository_interface.dart';

class UpdateCategoryUseCase {
  final CategoryRepositoryInterface _repository;

  UpdateCategoryUseCase(this._repository);

  Future<CategoryAdminModel> call(String categoryId, Map<String, dynamic> updateData) async {
    return await _repository.updateCategory(categoryId, updateData);
  }
}

