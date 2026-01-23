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

  Future<CatalogSection> getCatalogSectionById(String sectionId) async {
    try {
      final response = await _dioClient.dio.get(
        ApiEndpoints.adminCatalogLayoutById(sectionId),
      );

      if (response.statusCode == 200) {
        return CatalogSection.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load catalog section');
      }
    } on DioException catch (e) {
      throw Exception('Error fetching catalog section: ${e.message}');
    }
  }

  Future<CatalogSection> updateCatalogSection(
    String sectionId,
    Map<String, dynamic> updateData,
  ) async {
    try {
      final response = await _dioClient.dio.put(
        ApiEndpoints.adminCatalogLayoutById(sectionId),
        data: updateData,
      );

      if (response.statusCode == 200) {
        return CatalogSection.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to update catalog section');
      }
    } on DioException catch (e) {
      throw Exception('Error updating catalog section: ${e.message}');
    }
  }

  Future<CatalogSection> createCatalogSection(Map<String, dynamic> createData) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.adminCatalogLayout,
        data: createData,
      );

      if (response.statusCode == 201) {
        return CatalogSection.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to create catalog section');
      }
    } on DioException catch (e) {
      throw Exception('Error creating catalog section: ${e.message}');
    }
  }

  Future<void> deleteCatalogSection(String sectionId) async {
    try {
      final response = await _dioClient.dio.delete(
        ApiEndpoints.adminCatalogLayoutById(sectionId),
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to delete catalog section');
      }
    } on DioException catch (e) {
      throw Exception('Error deleting catalog section: ${e.message}');
    }
  }

  Future<List<CatalogSection>> bulkUpdateCatalogSections(Map<String, dynamic> bulkUpdateData) async {
    try {
      final response = await _dioClient.dio.patch(
        ApiEndpoints.adminCatalogLayoutBulk,
        data: bulkUpdateData,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => CatalogSection.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to bulk update catalog sections');
      }
    } on DioException catch (e) {
      throw Exception('Error bulk updating catalog sections: ${e.message}');
    }
  }
}


