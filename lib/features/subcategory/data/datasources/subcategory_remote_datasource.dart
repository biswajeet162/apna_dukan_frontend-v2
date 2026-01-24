// SubCategory Remote Data Source
import 'package:dio/dio.dart';
import '../models/subcategory_response.dart';
import '../models/subcategory_admin_response.dart';
import '../models/subcategory_admin_model.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_endpoints.dart';

class SubCategoryRemoteDataSource {
  final DioClient _dioClient;

  SubCategoryRemoteDataSource(this._dioClient);

  Future<SubCategoryResponse> getSubCategoriesForCategory(String categoryId) async {
    try {
      final response = await _dioClient.dio.get('/v1/category/$categoryId/subCategories');

      if (response.statusCode == 200) {
        return SubCategoryResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load subcategories');
      }
    } on DioException catch (e) {
      throw Exception('Error fetching subcategories: ${e.message}');
    }
  }

  Future<SubCategoryAdminResponse> getSubCategoriesForAdmin(String categoryId) async {
    try {
      final response = await _dioClient.dio.get(ApiEndpoints.adminSubCategoriesForCategory(categoryId));

      if (response.statusCode == 200) {
        return SubCategoryAdminResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load subcategories');
      }
    } on DioException catch (e) {
      throw Exception('Error fetching subcategories: ${e.message}');
    }
  }

  Future<SubCategoryAdminModel> getSubCategoryById(String subCategoryId) async {
    try {
      final response = await _dioClient.dio.get(ApiEndpoints.adminSubCategoryById(subCategoryId));

      if (response.statusCode == 200) {
        return SubCategoryAdminModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load subcategory');
      }
    } on DioException catch (e) {
      throw Exception('Error fetching subcategory: ${e.message}');
    }
  }

  Future<SubCategoryAdminModel> createSubCategory(Map<String, dynamic> createData) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.adminSubCategoryCreate,
        data: createData,
      );

      if (response.statusCode == 201) {
        return SubCategoryAdminModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to create subcategory');
      }
    } on DioException catch (e) {
      throw Exception('Error creating subcategory: ${e.message}');
    }
  }

  Future<SubCategoryAdminModel> updateSubCategory(String subCategoryId, Map<String, dynamic> updateData) async {
    try {
      final response = await _dioClient.dio.put(
        ApiEndpoints.adminSubCategoryById(subCategoryId),
        data: updateData,
      );

      if (response.statusCode == 200) {
        return SubCategoryAdminModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to update subcategory');
      }
    } on DioException catch (e) {
      throw Exception('Error updating subcategory: ${e.message}');
    }
  }

  Future<void> deleteSubCategory(String subCategoryId) async {
    try {
      final response = await _dioClient.dio.delete(
        ApiEndpoints.adminSubCategoryById(subCategoryId),
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to delete subcategory');
      }
    } on DioException catch (e) {
      throw Exception('Error deleting subcategory: ${e.message}');
    }
  }

  Future<List<SubCategoryAdminModel>> bulkUpdateSubCategories(Map<String, dynamic> bulkUpdateData) async {
    try {
      final response = await _dioClient.dio.patch(
        ApiEndpoints.adminSubCategoryBulk,
        data: bulkUpdateData,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((item) => SubCategoryAdminModel.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Failed to bulk update subcategories');
      }
    } on DioException catch (e) {
      throw Exception('Error bulk updating subcategories: ${e.message}');
    }
  }
}


