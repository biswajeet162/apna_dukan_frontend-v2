// Bulk Update Catalog Sections Use Case
import '../models/catalog_section.dart';
import '../repositories/catalog_layout_repository_interface.dart';

class BulkUpdateCatalogSectionsUseCase {
  final CatalogLayoutRepositoryInterface _repository;

  BulkUpdateCatalogSectionsUseCase(this._repository);

  Future<List<CatalogSection>> call(Map<String, dynamic> bulkUpdateData) async {
    return await _repository.bulkUpdateCatalogSections(bulkUpdateData);
  }
}

