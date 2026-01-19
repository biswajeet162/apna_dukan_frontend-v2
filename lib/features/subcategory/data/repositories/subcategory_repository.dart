// SubCategory Repository
import '../models/subcategory_response.dart';
import '../datasources/subcategory_remote_datasource.dart';
import '../../domain/repositories/subcategory_repository_interface.dart';

class SubCategoryRepository implements SubCategoryRepositoryInterface {
  final SubCategoryRemoteDataSource _remoteDataSource;

  SubCategoryRepository(this._remoteDataSource);

  @override
  Future<SubCategoryResponse> getSubCategoriesForCategory(String categoryId) async {
    return await _remoteDataSource.getSubCategoriesForCategory(categoryId);
  }
}
