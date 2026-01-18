// SubCategory Repository Interface
import '../models/subcategory_response.dart';

abstract class SubCategoryRepositoryInterface {
  Future<SubCategoryResponse> getSubCategoriesForCategory(String categoryId);
}

