// Create Category Use Case
import '../../data/models/category_admin_model.dart';
import '../repositories/category_repository_interface.dart';

class CreateCategoryUseCase {
  final CategoryRepositoryInterface _repository;

  CreateCategoryUseCase(this._repository);

  Future<CategoryAdminModel> call(Map<String, dynamic> createData) async {
    return await _repository.createCategory(createData);
  }
}

