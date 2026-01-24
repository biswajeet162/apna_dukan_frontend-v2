// Bulk Update Product Groups Use Case
import '../../data/models/product_group_admin_model.dart';
import '../repositories/product_group_repository_interface.dart';

class BulkUpdateProductGroupsUseCase {
  final ProductGroupRepositoryInterface _repository;

  BulkUpdateProductGroupsUseCase(this._repository);

  Future<List<ProductGroupAdminModel>> call(Map<String, dynamic> bulkUpdateData) async {
    return await _repository.bulkUpdateProductGroups(bulkUpdateData);
  }
}

