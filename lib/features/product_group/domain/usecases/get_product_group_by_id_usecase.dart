// Get Product Group By ID Use Case
import '../../data/models/product_group_admin_model.dart';
import '../repositories/product_group_repository_interface.dart';

class GetProductGroupByIdUseCase {
  final ProductGroupRepositoryInterface _repository;

  GetProductGroupByIdUseCase(this._repository);

  Future<ProductGroupAdminModel> call(String productGroupId) async {
    return await _repository.getProductGroupById(productGroupId);
  }
}

