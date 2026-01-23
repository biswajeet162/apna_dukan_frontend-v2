// Get Catalog Section By ID Use Case
import '../models/catalog_section.dart';
import '../repositories/catalog_layout_repository_interface.dart';

class GetCatalogSectionByIdUseCase {
  final CatalogLayoutRepositoryInterface _repository;

  GetCatalogSectionByIdUseCase(this._repository);

  Future<CatalogSection> call(String sectionId) async {
    return await _repository.getCatalogSectionById(sectionId);
  }
}

