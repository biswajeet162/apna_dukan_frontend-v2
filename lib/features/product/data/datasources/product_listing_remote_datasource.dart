// Product Listing Remote Data Source
import 'package:dio/dio.dart';
import '../models/product_listing_response.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_endpoints.dart';

class ProductListingRemoteDataSource {
  final DioClient _dioClient;

  ProductListingRemoteDataSource(this._dioClient);

  Future<ProductListingResponse> getProductListing(
    String productGroupId, {
    int page = 0,
    int size = 100, // Large size to get all products for now
  }) async {
    try {
      final url = ApiEndpoints.productsForProductGroupUrl(productGroupId);
      final response = await _dioClient.dio.get(
        url,
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      if (response.statusCode == 200) {
        return ProductListingResponse.fromJson(
            response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load product listing');
      }
    } on DioException catch (e) {
      throw Exception('Error fetching product listing: ${e.message}');
    }
  }
}

