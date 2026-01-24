// Bulk Update SubCategories Use Case
import '../../data/models/subcategory_admin_model.dart';
import '../repositories/subcategory_repository_interface.dart';

class BulkUpdateSubCategoriesUseCase {
  final SubCategoryRepositoryInterface _repository;

  BulkUpdateSubCategoriesUseCase(this._repository);

  Future<List<SubCategoryAdminModel>> call(Map<String, dynamic> bulkUpdateData) async {
    return await _repository.bulkUpdateSubCategories(bulkUpdateData);
  }
}

