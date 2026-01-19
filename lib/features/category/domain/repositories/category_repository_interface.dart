// Category Repository Interface
import '../../data/models/category_section_response.dart';

abstract class CategoryRepositoryInterface {
  Future<CategorySectionResponse> getCategoriesForSection(String sectionId);
}


