// Product Group Remote Data Source
import 'package:dio/dio.dart';
import '../models/product_group_response.dart';
import '../../../../core/network/dio_client.dart';

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
}

