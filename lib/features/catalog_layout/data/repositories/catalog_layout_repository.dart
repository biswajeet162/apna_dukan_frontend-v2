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
}

