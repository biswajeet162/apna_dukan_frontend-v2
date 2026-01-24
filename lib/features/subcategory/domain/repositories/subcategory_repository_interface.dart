// SubCategory Repository Interface
import '../../data/models/subcategory_response.dart';
import '../../data/models/subcategory_admin_response.dart';
import '../../data/models/subcategory_admin_model.dart';

abstract class SubCategoryRepositoryInterface {
  Future<SubCategoryResponse> getSubCategoriesForCategory(String categoryId);
  Future<SubCategoryAdminResponse> getSubCategoriesForAdmin(String categoryId);
  Future<SubCategoryAdminModel> getSubCategoryById(String subCategoryId);
  Future<SubCategoryAdminModel> createSubCategory(Map<String, dynamic> createData);
  Future<SubCategoryAdminModel> updateSubCategory(String subCategoryId, Map<String, dynamic> updateData);
  Future<void> deleteSubCategory(String subCategoryId);
}


