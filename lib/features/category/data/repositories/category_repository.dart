// Category Repository
import '../models/category_section_response.dart';
import '../models/category_section_admin_response.dart';
import '../models/category_admin_model.dart';
import '../datasources/category_remote_datasource.dart';
import '../../domain/repositories/category_repository_interface.dart';

class CategoryRepository implements CategoryRepositoryInterface {
  final CategoryRemoteDataSource _remoteDataSource;

  CategoryRepository(this._remoteDataSource);

  @override
  Future<CategorySectionResponse> getCategoriesForSection(String sectionId) async {
    return await _remoteDataSource.getCategoriesForSection(sectionId);
  }

  // Admin methods
  @override
  Future<CategorySectionAdminResponse> getCategoriesForAdmin(String sectionId) async {
    return await _remoteDataSource.getCategoriesForAdmin(sectionId);
  }

  @override
  Future<CategoryAdminModel> getCategoryById(String categoryId) async {
    return await _remoteDataSource.getCategoryById(categoryId);
  }

  @override
  Future<CategoryAdminModel> createCategory(Map<String, dynamic> createData) async {
    return await _remoteDataSource.createCategory(createData);
  }

  @override
  Future<CategoryAdminModel> updateCategory(String categoryId, Map<String, dynamic> updateData) async {
    return await _remoteDataSource.updateCategory(categoryId, updateData);
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    return await _remoteDataSource.deleteCategory(categoryId);
  }

  @override
  Future<List<CategoryAdminModel>> bulkUpdateCategories(Map<String, dynamic> bulkUpdateData) async {
    return await _remoteDataSource.bulkUpdateCategories(bulkUpdateData);
  }
}
