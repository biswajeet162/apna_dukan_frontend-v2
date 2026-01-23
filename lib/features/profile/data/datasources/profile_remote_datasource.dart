// Profile Remote Data Source
import 'package:dio/dio.dart';
import '../models/user_profile_response.dart';
import '../models/address_response.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_endpoints.dart';

class ProfileRemoteDataSource {
  final DioClient _dioClient;

  ProfileRemoteDataSource(this._dioClient);

  Future<UserProfileResponse> getUserProfile() async {
    try {
      // Endpoint: GET /api/user/profile
      // Token is automatically added by AuthInterceptor if user is logged in
      final response = await _dioClient.dio.get('/user/profile');

      if (response.statusCode == 200) {
        return UserProfileResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to get user profile');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // Token missing, invalid, or expired
        final errorData = e.response?.data;
        if (errorData is Map && errorData.containsKey('message')) {
          throw Exception(errorData['message'] as String);
        }
        throw Exception('Unauthorized. Please login again.');
      } else if (e.response?.statusCode == 403) {
        throw Exception('Access denied. You don\'t have permission.');
      } else if (e.response != null) {
        final errorData = e.response?.data;
        if (errorData is Map && errorData.containsKey('message')) {
          throw Exception(errorData['message'] as String);
        }
        throw Exception('Error fetching profile: ${e.response?.statusCode}');
      } else {
        throw Exception('Network error. Please check your connection.');
      }
    }
  }

  Future<List<AddressResponse>> getUserAddresses() async {
    try {
      // Endpoint: GET /api/user/addresses
      // Token is automatically added by AuthInterceptor if user is logged in
      final response = await _dioClient.dio.get('/user/addresses');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => AddressResponse.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to get addresses');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // Token missing, invalid, or expired
        final errorData = e.response?.data;
        if (errorData is Map && errorData.containsKey('message')) {
          throw Exception(errorData['message'] as String);
        }
        throw Exception('Unauthorized. Please login again.');
      } else if (e.response?.statusCode == 403) {
        throw Exception('Access denied. You don\'t have permission.');
      } else if (e.response != null) {
        final errorData = e.response?.data;
        if (errorData is Map && errorData.containsKey('message')) {
          throw Exception(errorData['message'] as String);
        }
        throw Exception('Error fetching addresses: ${e.response?.statusCode}');
      } else {
        throw Exception('Network error. Please check your connection.');
      }
    }
  }
}

