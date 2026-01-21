// Product Group Repository Interface
import '../../data/models/product_group_response.dart';

abstract class ProductGroupRepositoryInterface {
  Future<ProductGroupResponse> getProductGroupsForSubCategory(String subCategoryId);
}

