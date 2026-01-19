// Catalog Layout Repository Interface
import '../models/catalog_section.dart';

abstract class CatalogLayoutRepositoryInterface {
  Future<List<CatalogSection>> getEnabledCatalogSections();
}


