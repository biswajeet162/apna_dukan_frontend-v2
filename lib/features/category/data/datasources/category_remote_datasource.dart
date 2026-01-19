// Category Remote Data Source
import 'package:dio/dio.dart';
import '../models/category_section_response.dart';
import '../../../../core/network/dio_client.dart';

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
}


