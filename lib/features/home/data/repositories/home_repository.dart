// Home Repository
import '../models/section_model.dart';
import '../../../catalog_layout/data/repositories/catalog_layout_repository.dart';
import '../../../catalog_layout/domain/models/catalog_section.dart';

class HomeRepository {
  final CatalogLayoutRepository _catalogLayoutRepository;

  HomeRepository(this._catalogLayoutRepository);

  Future<List<SectionModel>> getSections() async {
    try {
      final catalogSections = await _catalogLayoutRepository.getEnabledCatalogSections();
      return catalogSections.map((section) => SectionModel(
        sectionId: section.sectionId,
        sectionCode: section.sectionCode,
        name: section.title,
        description: section.description,
        displayOrder: section.displayOrder,
        enabled: section.enabled,
      )).toList();
    } catch (e) {
      throw Exception('Failed to load sections: $e');
    }
  }
}



