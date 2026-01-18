// Get Catalog Layout Use Case
import '../models/catalog_section.dart';
import '../repositories/catalog_layout_repository_interface.dart';

class GetCatalogLayoutUseCase {
  final CatalogLayoutRepositoryInterface _repository;

  GetCatalogLayoutUseCase(this._repository);

  Future<List<CatalogSection>> call() async {
    return await _repository.getEnabledCatalogSections();
  }
}

