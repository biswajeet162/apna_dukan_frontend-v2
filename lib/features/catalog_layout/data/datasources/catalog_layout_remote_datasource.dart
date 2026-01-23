// Catalog Layout Remote Data Source
import 'package:dio/dio.dart';
import '../../domain/models/catalog_section.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_endpoints.dart';

class CatalogLayoutRemoteDataSource {
  final DioClient _dioClient;

  CatalogLayoutRemoteDataSource(this._dioClient);

  Future<List<CatalogSection>> getEnabledCatalogSections() async {
    try {
      final response = await _dioClient.dio.get(ApiEndpoints.catalogLayout);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => CatalogSection.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load catalog sections');
      }
    } on DioException catch (e) {
      throw Exception('Error fetching catalog sections: ${e.message}');
    }
  }

  Future<List<CatalogSection>> getAllCatalogSectionsForAdmin() async {
    try {
      final response = await _dioClient.dio.get(ApiEndpoints.adminCatalogLayout);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => CatalogSection.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load catalog sections');
      }
    } on DioException catch (e) {
      throw Exception('Error fetching catalog sections: ${e.message}');
    }
  }
}


