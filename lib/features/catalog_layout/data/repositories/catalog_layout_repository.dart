// Catalog Layout Repository
import '../../domain/models/catalog_section.dart';
import '../../domain/repositories/catalog_layout_repository_interface.dart';
import '../datasources/catalog_layout_remote_datasource.dart';

class CatalogLayoutRepository implements CatalogLayoutRepositoryInterface {
  final CatalogLayoutRemoteDataSource _remoteDataSource;

  CatalogLayoutRepository(this._remoteDataSource);

  @override
  Future<List<CatalogSection>> getEnabledCatalogSections() async {
    return await _remoteDataSource.getEnabledCatalogSections();
  }

  @override
  Future<List<CatalogSection>> getAllCatalogSectionsForAdmin() async {
    return await _remoteDataSource.getAllCatalogSectionsForAdmin();
  }

  @override
  Future<CatalogSection> getCatalogSectionById(String sectionId) async {
    return await _remoteDataSource.getCatalogSectionById(sectionId);
  }

  @override
  Future<CatalogSection> updateCatalogSection(String sectionId, Map<String, dynamic> updateData) async {
    return await _remoteDataSource.updateCatalogSection(sectionId, updateData);
  }

  @override
  Future<CatalogSection> createCatalogSection(Map<String, dynamic> createData) async {
    return await _remoteDataSource.createCatalogSection(createData);
  }

  @override
  Future<void> deleteCatalogSection(String sectionId) async {
    return await _remoteDataSource.deleteCatalogSection(sectionId);
  }

  @override
  Future<List<CatalogSection>> bulkUpdateCatalogSections(Map<String, dynamic> bulkUpdateData) async {
    return await _remoteDataSource.bulkUpdateCatalogSections(bulkUpdateData);
  }
}

