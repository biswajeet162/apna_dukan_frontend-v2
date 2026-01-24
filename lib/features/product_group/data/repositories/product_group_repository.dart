// Product Group Repository
import '../models/product_group_response.dart';
import '../models/product_group_admin_model.dart';
import '../datasources/product_group_remote_datasource.dart';
import '../../domain/repositories/product_group_repository_interface.dart';

class ProductGroupRepository implements ProductGroupRepositoryInterface {
  final ProductGroupRemoteDataSource _remoteDataSource;

  ProductGroupRepository(this._remoteDataSource);

  @override
  Future<ProductGroupResponse> getProductGroupsForSubCategory(String subCategoryId) async {
    return await _remoteDataSource.getProductGroupsForSubCategory(subCategoryId);
  }

  @override
  Future<ProductGroupResponse> getProductGroupsForSubCategoryAdmin(String subCategoryId) async {
    return await _remoteDataSource.getProductGroupsForSubCategoryAdmin(subCategoryId);
  }

  @override
  Future<ProductGroupAdminModel> getProductGroupById(String productGroupId) async {
    return await _remoteDataSource.getProductGroupById(productGroupId);
  }

  @override
  Future<ProductGroupAdminModel> createProductGroup(Map<String, dynamic> createData) async {
    return await _remoteDataSource.createProductGroup(createData);
  }

  @override
  Future<ProductGroupAdminModel> updateProductGroup(
    String productGroupId,
    Map<String, dynamic> updateData,
  ) async {
    return await _remoteDataSource.updateProductGroup(productGroupId, updateData);
  }

  @override
  Future<void> deleteProductGroup(String productGroupId) async {
    return await _remoteDataSource.deleteProductGroup(productGroupId);
  }
}



