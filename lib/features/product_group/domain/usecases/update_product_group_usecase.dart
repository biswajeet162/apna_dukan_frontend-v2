// Update Product Group Use Case
import '../../data/models/product_group_admin_model.dart';
import '../repositories/product_group_repository_interface.dart';

class UpdateProductGroupUseCase {
  final ProductGroupRepositoryInterface _repository;

  UpdateProductGroupUseCase(this._repository);

  Future<ProductGroupAdminModel> call(
    String productGroupId,
    Map<String, dynamic> updateData,
  ) async {
    return await _repository.updateProductGroup(productGroupId, updateData);
  }
}

