// Product Group Repository Interface
import '../../data/models/product_group_response.dart';
import '../../data/models/product_group_admin_model.dart';

abstract class ProductGroupRepositoryInterface {
  Future<ProductGroupResponse> getProductGroupsForSubCategory(String subCategoryId);
  Future<ProductGroupResponse> getProductGroupsForSubCategoryAdmin(String subCategoryId);
  Future<ProductGroupAdminModel> getProductGroupById(String productGroupId);
  Future<ProductGroupAdminModel> createProductGroup(Map<String, dynamic> createData);
  Future<ProductGroupAdminModel> updateProductGroup(String productGroupId, Map<String, dynamic> updateData);
  Future<void> deleteProductGroup(String productGroupId);
}


