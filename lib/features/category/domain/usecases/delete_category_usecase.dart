// Delete Category Use Case
import '../repositories/category_repository_interface.dart';

class DeleteCategoryUseCase {
  final CategoryRepositoryInterface _repository;

  DeleteCategoryUseCase(this._repository);

  Future<void> call(String categoryId) async {
    return await _repository.deleteCategory(categoryId);
  }
}

