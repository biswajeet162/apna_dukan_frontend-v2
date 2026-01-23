// Create Catalog Section Use Case
import '../models/catalog_section.dart';
import '../repositories/catalog_layout_repository_interface.dart';

class CreateCatalogSectionUseCase {
  final CatalogLayoutRepositoryInterface _repository;

  CreateCatalogSectionUseCase(this._repository);

  Future<CatalogSection> call(Map<String, dynamic> createData) async {
    return await _repository.createCatalogSection(createData);
  }
}

