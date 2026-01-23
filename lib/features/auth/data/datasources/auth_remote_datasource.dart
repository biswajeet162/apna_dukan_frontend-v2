// Auth Remote Data Source
import 'package:dio/dio.dart';
import '../models/login_request.dart';
import '../models/signup_request.dart';
import '../models/auth_response.dart';
import '../models/refresh_token_request.dart';
import '../models/refresh_token_response.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_endpoints.dart';

class AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSource(this._dioClient);

  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.login,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to login');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        final errorData = e.response?.data;
        if (errorData is Map && errorData.containsKey('message')) {
          throw Exception(errorData['message'] as String);
        }
        throw Exception('Invalid email/phone or password');
      } else if (e.response?.statusCode == 400) {
        final errorData = e.response?.data;
        if (errorData is Map) {
          if (errorData.containsKey('message')) {
            throw Exception(errorData['message'] as String);
          }
          // Handle validation errors
          if (errorData.containsKey('errors')) {
            final errors = errorData['errors'] as Map<String, dynamic>?;
            if (errors != null && errors.isNotEmpty) {
              final firstError = errors.values.first;
              if (firstError is List && firstError.isNotEmpty) {
                throw Exception(firstError.first as String);
              }
            }
          }
        }
        throw Exception('Invalid request: ${e.response?.data}');
      } else {
        throw Exception('Error during login: ${e.message}');
      }
    }
  }

  Future<AuthResponse> signup(SignupRequest request) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.signup,
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to sign up');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final errorData = e.response?.data;
        if (errorData is Map) {
          if (errorData.containsKey('message')) {
            throw Exception(errorData['message'] as String);
          }
          // Handle validation errors
          if (errorData.containsKey('errors')) {
            final errors = errorData['errors'] as Map<String, dynamic>?;
            if (errors != null && errors.isNotEmpty) {
              final firstError = errors.values.first;
              if (firstError is List && firstError.isNotEmpty) {
                throw Exception(firstError.first as String);
              }
            }
          }
        }
        throw Exception('Invalid request: ${e.response?.data}');
      } else if (e.response?.statusCode == 409) {
        throw Exception('User already exists');
      } else {
        throw Exception('Error during signup: ${e.message}');
      }
    }
  }

  Future<RefreshTokenResponse> refreshToken(RefreshTokenRequest request) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.refreshToken,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return RefreshTokenResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to refresh token');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Invalid or expired refresh token');
      } else {
        throw Exception('Error during token refresh: ${e.message}');
      }
    }
  }
}



