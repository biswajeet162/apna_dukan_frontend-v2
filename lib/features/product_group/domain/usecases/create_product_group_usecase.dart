// Create Product Group Use Case
import '../../data/models/product_group_admin_model.dart';
import '../repositories/product_group_repository_interface.dart';

class CreateProductGroupUseCase {
  final ProductGroupRepositoryInterface _repository;

  CreateProductGroupUseCase(this._repository);

  Future<ProductGroupAdminModel> call(Map<String, dynamic> createData) async {
    return await _repository.createProductGroup(createData);
  }
}

