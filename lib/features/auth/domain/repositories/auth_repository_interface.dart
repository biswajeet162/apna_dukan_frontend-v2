// Auth Repository Interface
import '../../data/models/login_request.dart';
import '../../data/models/signup_request.dart';
import '../../data/models/auth_response.dart';

abstract class AuthRepositoryInterface {
  Future<AuthResponse> login(LoginRequest request);
  Future<AuthResponse> signup(SignupRequest request);
}

