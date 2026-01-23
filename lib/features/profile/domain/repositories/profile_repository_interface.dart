// Profile Repository Interface
import '../../data/models/user_profile_response.dart';
import '../../data/models/address_response.dart';

abstract class ProfileRepositoryInterface {
  Future<UserProfileResponse> getUserProfile();
  Future<List<AddressResponse>> getUserAddresses();
}

