// Delete SubCategory Use Case
import '../repositories/subcategory_repository_interface.dart';

class DeleteSubCategoryUseCase {
  final SubCategoryRepositoryInterface _repository;

  DeleteSubCategoryUseCase(this._repository);

  Future<void> call(String subCategoryId) async {
    return await _repository.deleteSubCategory(subCategoryId);
  }
}

