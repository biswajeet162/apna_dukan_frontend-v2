// Get SubCategories For Admin Use Case
import '../../data/models/subcategory_admin_response.dart';
import '../repositories/subcategory_repository_interface.dart';

class GetSubCategoriesForAdminUseCase {
  final SubCategoryRepositoryInterface _repository;

  GetSubCategoriesForAdminUseCase(this._repository);

  Future<SubCategoryAdminResponse> call(String categoryId) async {
    return await _repository.getSubCategoriesForAdmin(categoryId);
  }
}

