// Product Group Repository
import '../models/product_group_response.dart';
import '../datasources/product_group_remote_datasource.dart';
import '../../domain/repositories/product_group_repository_interface.dart';

class ProductGroupRepository implements ProductGroupRepositoryInterface {
  final ProductGroupRemoteDataSource _remoteDataSource;

  ProductGroupRepository(this._remoteDataSource);

  @override
  Future<ProductGroupResponse> getProductGroupsForSubCategory(String subCategoryId) async {
    return await _remoteDataSource.getProductGroupsForSubCategory(subCategoryId);
  }
}



