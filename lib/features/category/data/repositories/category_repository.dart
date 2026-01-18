// Category Repository
import '../../domain/models/category_section_response.dart';
import '../../domain/repositories/category_repository_interface.dart';
import '../datasources/category_remote_datasource.dart';

class CategoryRepository implements CategoryRepositoryInterface {
  final CategoryRemoteDataSource _remoteDataSource;

  CategoryRepository(this._remoteDataSource);

  @override
  Future<CategorySectionResponse> getCategoriesForSection(String sectionId) async {
    return await _remoteDataSource.getCategoriesForSection(sectionId);
  }
}

