// Get All Catalog Layouts Use Case (Admin)
import '../models/catalog_section.dart';
import '../repositories/catalog_layout_repository_interface.dart';

class GetAllCatalogLayoutsUseCase {
  final CatalogLayoutRepositoryInterface _repository;

  GetAllCatalogLayoutsUseCase(this._repository);

  Future<List<CatalogSection>> call() async {
    return await _repository.getAllCatalogSectionsForAdmin();
  }
}

