// Get Product Groups Use Case
import '../../data/models/product_group_response.dart';
import '../repositories/product_group_repository_interface.dart';

class GetProductGroupsUseCase {
  final ProductGroupRepositoryInterface _repository;

  GetProductGroupsUseCase(this._repository);

  Future<ProductGroupResponse> call(String subCategoryId) async {
    return await _repository.getProductGroupsForSubCategory(subCategoryId);
  }
}


