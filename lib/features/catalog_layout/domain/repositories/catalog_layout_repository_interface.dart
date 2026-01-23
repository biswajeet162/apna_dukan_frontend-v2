// Catalog Layout Repository Interface
import '../models/catalog_section.dart';

abstract class CatalogLayoutRepositoryInterface {
  Future<List<CatalogSection>> getEnabledCatalogSections();
  Future<List<CatalogSection>> getAllCatalogSectionsForAdmin();
  Future<CatalogSection> getCatalogSectionById(String sectionId);
  Future<CatalogSection> updateCatalogSection(String sectionId, Map<String, dynamic> updateData);
  Future<CatalogSection> createCatalogSection(Map<String, dynamic> createData);
  Future<void> deleteCatalogSection(String sectionId);
  Future<List<CatalogSection>> bulkUpdateCatalogSections(Map<String, dynamic> bulkUpdateData);
}


