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

  Future<ProductGroupAdminModel> getProductGroupById(String productGroupId) async {
    try {
      final response = await _dioClient.dio.get(
        ApiEndpoints.adminProductGroupById(productGroupId),
      );

      if (response.statusCode == 200) {
        return ProductGroupAdminModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load product group');
      }
    } on DioException catch (e) {
      throw Exception('Error fetching product group: ${e.message}');
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

  Future<ProductGroupAdminModel> updateProductGroup(
    String productGroupId,
    Map<String, dynamic> updateData,
  ) async {
    try {
      final response = await _dioClient.dio.put(
        ApiEndpoints.adminProductGroupById(productGroupId),
        data: updateData,
      );

      if (response.statusCode == 200) {
        return ProductGroupAdminModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to update product group');
      }
    } on DioException catch (e) {
      throw Exception('Error updating product group: ${e.message}');
    }
  }

  Future<void> deleteProductGroup(String productGroupId) async {
    try {
      final response = await _dioClient.dio.delete(
        ApiEndpoints.adminProductGroupById(productGroupId),
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to delete product group');
      }
    } on DioException catch (e) {
      throw Exception('Error deleting product group: ${e.message}');
    }
  }

  Future<List<ProductGroupAdminModel>> bulkUpdateProductGroups(Map<String, dynamic> bulkUpdateData) async {
    try {
      final response = await _dioClient.dio.patch(
        ApiEndpoints.adminProductGroupBulk,
        data: bulkUpdateData,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data
            .map((item) => ProductGroupAdminModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to bulk update product groups');
      }
    } on DioException catch (e) {
      throw Exception('Error bulk updating product groups: ${e.message}');
    }
  }
}


