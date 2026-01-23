// Update Catalog Section Use Case
import '../models/catalog_section.dart';
import '../repositories/catalog_layout_repository_interface.dart';

class UpdateCatalogSectionUseCase {
  final CatalogLayoutRepositoryInterface _repository;

  UpdateCatalogSectionUseCase(this._repository);

  Future<CatalogSection> call(String sectionId, Map<String, dynamic> updateData) async {
    return await _repository.updateCatalogSection(sectionId, updateData);
  }
}

