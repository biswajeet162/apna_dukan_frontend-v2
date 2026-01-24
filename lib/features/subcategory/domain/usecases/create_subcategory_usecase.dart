// Create SubCategory Use Case
import '../../data/models/subcategory_admin_model.dart';
import '../repositories/subcategory_repository_interface.dart';

class CreateSubCategoryUseCase {
  final SubCategoryRepositoryInterface _repository;

  CreateSubCategoryUseCase(this._repository);

  Future<SubCategoryAdminModel> call(Map<String, dynamic> createData) async {
    return await _repository.createSubCategory(createData);
  }
}

