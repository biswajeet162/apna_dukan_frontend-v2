// Bulk Update Categories Use Case
import '../../data/models/category_admin_model.dart';
import '../repositories/category_repository_interface.dart';

class BulkUpdateCategoriesUseCase {
  final CategoryRepositoryInterface _repository;

  BulkUpdateCategoriesUseCase(this._repository);

  Future<List<CategoryAdminModel>> call(Map<String, dynamic> bulkUpdateData) async {
    return await _repository.bulkUpdateCategories(bulkUpdateData);
  }
}

