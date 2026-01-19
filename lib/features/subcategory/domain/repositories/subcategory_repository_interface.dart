// SubCategory Repository Interface
import '../../data/models/subcategory_response.dart';

abstract class SubCategoryRepositoryInterface {
  Future<SubCategoryResponse> getSubCategoriesForCategory(String categoryId);
}


