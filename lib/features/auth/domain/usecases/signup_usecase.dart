// Signup Use Case
import '../../data/models/signup_request.dart';
import '../../data/models/auth_response.dart';
import '../repositories/auth_repository_interface.dart';

class SignupUseCase {
  final AuthRepositoryInterface _repository;

  SignupUseCase(this._repository);

  Future<AuthResponse> call(SignupRequest request) async {
    return await _repository.signup(request);
  }
}

