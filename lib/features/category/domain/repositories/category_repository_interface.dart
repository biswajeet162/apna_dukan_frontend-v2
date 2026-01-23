// Category Repository Interface
import '../../data/models/category_section_response.dart';
import '../../data/models/category_section_admin_response.dart';
import '../../data/models/category_admin_model.dart';

abstract class CategoryRepositoryInterface {
  Future<CategorySectionResponse> getCategoriesForSection(String sectionId);
  
  // Admin methods
  Future<CategorySectionAdminResponse> getCategoriesForAdmin(String sectionId);
  Future<CategoryAdminModel> getCategoryById(String categoryId);
  Future<CategoryAdminModel> createCategory(Map<String, dynamic> createData);
  Future<CategoryAdminModel> updateCategory(String categoryId, Map<String, dynamic> updateData);
  Future<void> deleteCategory(String categoryId);
  Future<List<CategoryAdminModel>> bulkUpdateCategories(Map<String, dynamic> bulkUpdateData);
}


