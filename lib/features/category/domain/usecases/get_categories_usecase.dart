// Get Categories Use Case
import '../../data/models/category_section_response.dart';
import '../repositories/category_repository_interface.dart';

class GetCategoriesUseCase {
  final CategoryRepositoryInterface _repository;

  GetCategoriesUseCase(this._repository);

  Future<CategorySectionResponse> call(String sectionId) async {
    return await _repository.getCategoriesForSection(sectionId);
  }
}


