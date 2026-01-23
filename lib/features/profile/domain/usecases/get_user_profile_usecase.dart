// Get User Profile Use Case
import '../../data/models/user_profile_response.dart';
import '../repositories/profile_repository_interface.dart';

class GetUserProfileUseCase {
  final ProfileRepositoryInterface _repository;

  GetUserProfileUseCase(this._repository);

  Future<UserProfileResponse> call() async {
    return await _repository.getUserProfile();
  }
}

