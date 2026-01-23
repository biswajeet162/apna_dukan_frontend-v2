// Auth Service
import '../storage/secure_storage.dart';
import '../../features/auth/data/models/auth_response.dart';
import '../../features/auth/data/models/refresh_token_response.dart';

class AuthService {
  final SecureStorage _secureStorage;

  AuthService(this._secureStorage);

  // Save authentication data
  Future<void> saveAuthData(AuthResponse response) async {
    // Save tokens first (most critical)
    await _secureStorage.saveTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );
    
    // Then save user data
    await _secureStorage.saveUserId(response.userId);
    if (response.email != null) {
      await _secureStorage.saveUserEmail(response.email!);
    }
    await _secureStorage.saveUserRole(response.role);
    
    // Verify all data is saved
    final savedAccessToken = await _secureStorage.getAccessToken();
    final savedRefreshToken = await _secureStorage.getRefreshToken();
    final savedUserId = await _secureStorage.getUserId();
    
    if (savedAccessToken != response.accessToken || 
        savedRefreshToken != response.refreshToken ||
        savedUserId != response.userId) {
      throw Exception('Failed to save authentication data correctly');
    }
  }

  // Update tokens after refresh
  Future<void> updateTokens(RefreshTokenResponse response) async {
    await _secureStorage.updateTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );
  }

  // Get authentication token (access token)
  Future<String?> getToken() async {
    return await _secureStorage.getAccessToken();
  }

  // Get refresh token
  Future<String?> getRefreshToken() async {
    return await _secureStorage.getRefreshToken();
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
    return await _secureStorage.isLoggedIn();
  }

  // Check if user is admin
  Future<bool> isAdmin() async {
    final role = await getUserRole();
    return role == 'ADMIN' || role == 'ROLE_ADMIN';
  }

  // Logout - clear all auth data
  Future<void> logout() async {
    await _secureStorage.clearAll();
  }
}

