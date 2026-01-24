// Get SubCategory By ID Use Case
import '../../data/models/subcategory_admin_model.dart';
import '../repositories/subcategory_repository_interface.dart';

class GetSubCategoryByIdUseCase {
  final SubCategoryRepositoryInterface _repository;

  GetSubCategoryByIdUseCase(this._repository);

  Future<SubCategoryAdminModel> call(String subCategoryId) async {
    return await _repository.getSubCategoryById(subCategoryId);
  }
}

