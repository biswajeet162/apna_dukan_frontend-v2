// Auth Repository
import '../models/login_request.dart';
import '../models/signup_request.dart';
import '../models/auth_response.dart';
import '../datasources/auth_remote_datasource.dart';
import '../../domain/repositories/auth_repository_interface.dart';

class AuthRepository implements AuthRepositoryInterface {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepository(this._remoteDataSource);

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    return await _remoteDataSource.login(request);
  }

  @override
  Future<AuthResponse> signup(SignupRequest request) async {
    return await _remoteDataSource.signup(request);
  }
}

