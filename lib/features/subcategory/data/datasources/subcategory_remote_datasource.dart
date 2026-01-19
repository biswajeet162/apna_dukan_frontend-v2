// SubCategory Remote Data Source
import 'package:dio/dio.dart';
import '../../domain/models/subcategory_response.dart';
import '../../../../core/network/dio_client.dart';

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
}


