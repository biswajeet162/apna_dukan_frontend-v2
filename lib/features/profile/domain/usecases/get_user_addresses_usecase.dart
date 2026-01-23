// Get User Addresses Use Case
import '../../data/models/address_response.dart';
import '../repositories/profile_repository_interface.dart';

class GetUserAddressesUseCase {
  final ProfileRepositoryInterface _repository;

  GetUserAddressesUseCase(this._repository);

  Future<List<AddressResponse>> call() async {
    return await _repository.getUserAddresses();
  }
}

