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
      final response = await _dioClient.dio.get('/user/profile');

      if (response.statusCode == 200) {
        return UserProfileResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to get user profile');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else {
        throw Exception('Error fetching profile: ${e.message}');
      }
    }
  }

  Future<List<AddressResponse>> getUserAddresses() async {
    try {
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
        throw Exception('Unauthorized. Please login again.');
      } else {
        throw Exception('Error fetching addresses: ${e.message}');
      }
    }
  }
}

