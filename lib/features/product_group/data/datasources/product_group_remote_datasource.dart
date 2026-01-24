// Product Group Remote Data Source
import 'package:dio/dio.dart';
import '../models/product_group_response.dart';
import '../models/product_group_admin_model.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_endpoints.dart';

class ProductGroupRemoteDataSource {
  final DioClient _dioClient;

  ProductGroupRemoteDataSource(this._dioClient);

  Future<ProductGroupResponse> getProductGroupsForSubCategory(String subCategoryId) async {
    try {
      final response = await _dioClient.dio.get('/v1/subCategory/$subCategoryId/productGroups');

      if (response.statusCode == 200) {
        return ProductGroupResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load product groups');
      }
    } on DioException catch (e) {
      throw Exception('Error fetching product groups: ${e.message}');
    }
  }

  Future<ProductGroupResponse> getProductGroupsForSubCategoryAdmin(String subCategoryId) async {
    try {
      final response = await _dioClient.dio.get(
        ApiEndpoints.adminProductGroupsForSubCategory(subCategoryId),
      );

      if (response.statusCode == 200) {
        return ProductGroupResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load product groups');
      }
    } on DioException catch (e) {
      throw Exception('Error fetching product groups: ${e.message}');
    }
  }

  Future<ProductGroupAdminModel> createProductGroup(Map<String, dynamic> createData) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.adminProductGroupCreate,
        data: createData,
      );

      if (response.statusCode == 201) {
        return ProductGroupAdminModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to create product group');
      }
    } on DioException catch (e) {
      throw Exception('Error creating product group: ${e.message}');
    }
  }
}


