// Delete Product Group Use Case
import '../repositories/product_group_repository_interface.dart';

class DeleteProductGroupUseCase {
  final ProductGroupRepositoryInterface _repository;

  DeleteProductGroupUseCase(this._repository);

  Future<void> call(String productGroupId) async {
    return await _repository.deleteProductGroup(productGroupId);
  }
}

