// SubCategory Repository Interface
import '../../data/models/subcategory_response.dart';
import '../../data/models/subcategory_admin_response.dart';

abstract class SubCategoryRepositoryInterface {
  Future<SubCategoryResponse> getSubCategoriesForCategory(String categoryId);
  Future<SubCategoryAdminResponse> getSubCategoriesForAdmin(String categoryId);
}


