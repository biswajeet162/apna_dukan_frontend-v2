// Product Group Response Model
import 'product_group_model.dart';

class ProductGroupResponse {
  final String subCategoryId;
  final String subCategoryName;
  final List<ProductGroupModel> productGroups;

  ProductGroupResponse({
    required this.subCategoryId,
    required this.subCategoryName,
    required this.productGroups,
  });

  factory ProductGroupResponse.fromJson(Map<String, dynamic> json) {
    return ProductGroupResponse(
      subCategoryId: json['subCategoryId'] as String,
      subCategoryName: json['subCategoryName'] as String,
      productGroups: (json['productGroups'] as List<dynamic>?)
              ?.map((item) => ProductGroupModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subCategoryId': subCategoryId,
      'subCategoryName': subCategoryName,
      'productGroups': productGroups.map((pg) => pg.toJson()).toList(),
    };
  }
}


