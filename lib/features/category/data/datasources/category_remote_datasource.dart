// Category Remote Data Source
import 'package:dio/dio.dart';
import '../models/category_section_response.dart';
import '../models/category_section_admin_response.dart';
import '../models/category_admin_model.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_endpoints.dart';

class CategoryRemoteDataSource {
  final DioClient _dioClient;

  CategoryRemoteDataSource(this._dioClient);

  Future<CategorySectionResponse> getCategoriesForSection(String sectionId) async {
    try {
      final response = await _dioClient.dio.get('/v1/section/$sectionId/categories');

      if (response.statusCode == 200) {
        return CategorySectionResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load categories');
      }
    } on DioException catch (e) {
      throw Exception('Error fetching categories: ${e.message}');
    }
  }

  // Admin methods
  Future<CategorySectionAdminResponse> getCategoriesForAdmin(String sectionId) async {
    try {
      final response = await _dioClient.dio.get(
        ApiEndpoints.adminCategoriesForSection(sectionId),
      );

      if (response.statusCode == 200) {
        return CategorySectionAdminResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load categories');
      }
    } on DioException catch (e) {
      throw Exception('Error fetching categories: ${e.message}');
    }
  }

  Future<CategoryAdminModel> getCategoryById(String categoryId) async {
    try {
      final response = await _dioClient.dio.get(
        ApiEndpoints.adminCategoryById(categoryId),
      );

      if (response.statusCode == 200) {
        return CategoryAdminModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load category');
      }
    } on DioException catch (e) {
      throw Exception('Error fetching category: ${e.message}');
    }
  }

  Future<CategoryAdminModel> createCategory(Map<String, dynamic> createData) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.adminCategoryCreate,
        data: createData,
      );

      if (response.statusCode == 201) {
        return CategoryAdminModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to create category');
      }
    } on DioException catch (e) {
      throw Exception('Error creating category: ${e.message}');
    }
  }

  Future<CategoryAdminModel> updateCategory(String categoryId, Map<String, dynamic> updateData) async {
    try {
      final response = await _dioClient.dio.put(
        ApiEndpoints.adminCategoryById(categoryId),
        data: updateData,
      );

      if (response.statusCode == 200) {
        return CategoryAdminModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to update category');
      }
    } on DioException catch (e) {
      throw Exception('Error updating category: ${e.message}');
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    try {
      final response = await _dioClient.dio.delete(
        ApiEndpoints.adminCategoryById(categoryId),
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to delete category');
      }
    } on DioException catch (e) {
      throw Exception('Error deleting category: ${e.message}');
    }
  }

  Future<List<CategoryAdminModel>> bulkUpdateCategories(Map<String, dynamic> bulkUpdateData) async {
    try {
      final response = await _dioClient.dio.patch(
        ApiEndpoints.adminCategoryBulk,
        data: bulkUpdateData,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => CategoryAdminModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to bulk update categories');
      }
    } on DioException catch (e) {
      throw Exception('Error bulk updating categories: ${e.message}');
    }
  }
}


