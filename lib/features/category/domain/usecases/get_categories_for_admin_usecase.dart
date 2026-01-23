// Get Categories For Admin Use Case
import '../../data/models/category_section_admin_response.dart';
import '../repositories/category_repository_interface.dart';

class GetCategoriesForAdminUseCase {
  final CategoryRepositoryInterface _repository;

  GetCategoriesForAdminUseCase(this._repository);

  Future<CategorySectionAdminResponse> call(String sectionId) async {
    return await _repository.getCategoriesForAdmin(sectionId);
  }
}

