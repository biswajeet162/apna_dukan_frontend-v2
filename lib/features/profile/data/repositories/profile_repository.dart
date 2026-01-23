// Profile Repository
import '../models/user_profile_response.dart';
import '../models/address_response.dart';
import '../datasources/profile_remote_datasource.dart';
import '../../domain/repositories/profile_repository_interface.dart';

class ProfileRepository implements ProfileRepositoryInterface {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepository(this._remoteDataSource);

  @override
  Future<UserProfileResponse> getUserProfile() async {
    return await _remoteDataSource.getUserProfile();
  }

  @override
  Future<List<AddressResponse>> getUserAddresses() async {
    return await _remoteDataSource.getUserAddresses();
  }
}

