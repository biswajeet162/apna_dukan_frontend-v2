// Update SubCategory Use Case
import '../../data/models/subcategory_admin_model.dart';
import '../repositories/subcategory_repository_interface.dart';

class UpdateSubCategoryUseCase {
  final SubCategoryRepositoryInterface _repository;

  UpdateSubCategoryUseCase(this._repository);

  Future<SubCategoryAdminModel> call(String subCategoryId, Map<String, dynamic> updateData) async {
    return await _repository.updateSubCategory(subCategoryId, updateData);
  }
}

