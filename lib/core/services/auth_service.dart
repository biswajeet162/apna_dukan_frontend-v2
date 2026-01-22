// Auth Service
import '../storage/secure_storage.dart';
import '../../features/auth/data/models/auth_response.dart';

class AuthService {
  final SecureStorage _secureStorage;

  AuthService(this._secureStorage);

  // Save authentication data
  Future<void> saveAuthData(AuthResponse response) async {
    await _secureStorage.saveToken(response.token);
    await _secureStorage.saveUserId(response.id);
    await _secureStorage.saveUserEmail(response.email);
    await _secureStorage.saveUserRole(response.role);
  }

  // Get authentication token
  Future<String?> getToken() async {
    return await _secureStorage.getToken();
  }

  // Get user ID
  Future<String?> getUserId() async {
    return await _secureStorage.getUserId();
  }

  // Get user email
  Future<String?> getUserEmail() async {
    return await _secureStorage.getUserEmail();
  }

  // Get user role
  Future<String?> getUserRole() async {
    return await _secureStorage.getUserRole();
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Check if user is admin
  Future<bool> isAdmin() async {
    final role = await getUserRole();
    return role == 'ADMIN_ROLE';
  }

  // Logout - clear all auth data
  Future<void> logout() async {
    await _secureStorage.clearAll();
  }
}

