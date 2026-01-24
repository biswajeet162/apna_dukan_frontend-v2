// SubCategory Repository
import '../models/subcategory_response.dart';
import '../models/subcategory_admin_response.dart';
import '../models/subcategory_admin_model.dart';
import '../datasources/subcategory_remote_datasource.dart';
import '../../domain/repositories/subcategory_repository_interface.dart';

class SubCategoryRepository implements SubCategoryRepositoryInterface {
  final SubCategoryRemoteDataSource _remoteDataSource;

  SubCategoryRepository(this._remoteDataSource);

  @override
  Future<SubCategoryResponse> getSubCategoriesForCategory(String categoryId) async {
    return await _remoteDataSource.getSubCategoriesForCategory(categoryId);
  }

  @override
  Future<SubCategoryAdminResponse> getSubCategoriesForAdmin(String categoryId) async {
    return await _remoteDataSource.getSubCategoriesForAdmin(categoryId);
  }

  @override
  Future<SubCategoryAdminModel> getSubCategoryById(String subCategoryId) async {
    return await _remoteDataSource.getSubCategoryById(subCategoryId);
  }

  @override
  Future<SubCategoryAdminModel> createSubCategory(Map<String, dynamic> createData) async {
    return await _remoteDataSource.createSubCategory(createData);
  }

  @override
  Future<SubCategoryAdminModel> updateSubCategory(String subCategoryId, Map<String, dynamic> updateData) async {
    return await _remoteDataSource.updateSubCategory(subCategoryId, updateData);
  }

  @override
  Future<void> deleteSubCategory(String subCategoryId) async {
    return await _remoteDataSource.deleteSubCategory(subCategoryId);
  }

  @override
  Future<List<SubCategoryAdminModel>> bulkUpdateSubCategories(Map<String, dynamic> bulkUpdateData) async {
    return await _remoteDataSource.bulkUpdateSubCategories(bulkUpdateData);
  }
}
