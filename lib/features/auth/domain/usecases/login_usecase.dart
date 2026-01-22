// Login Use Case
import '../../data/models/login_request.dart';
import '../../data/models/auth_response.dart';
import '../repositories/auth_repository_interface.dart';

class LoginUseCase {
  final AuthRepositoryInterface _repository;

  LoginUseCase(this._repository);

  Future<AuthResponse> call(LoginRequest request) async {
    return await _repository.login(request);
  }
}

