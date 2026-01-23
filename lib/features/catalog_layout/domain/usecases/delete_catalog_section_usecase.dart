// Delete Catalog Section Use Case
import '../repositories/catalog_layout_repository_interface.dart';

class DeleteCatalogSectionUseCase {
  final CatalogLayoutRepositoryInterface _repository;

  DeleteCatalogSectionUseCase(this._repository);

  Future<void> call(String sectionId) async {
    return await _repository.deleteCatalogSection(sectionId);
  }
}

