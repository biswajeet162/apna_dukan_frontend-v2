// SubCategory Admin Response Model
import 'subcategory_admin_model.dart';

class SubCategoryAdminResponse {
  final String categoryId;
  final String categoryName;
  final List<SubCategoryAdminModel> subCategories;

  SubCategoryAdminResponse({
    required this.categoryId,
    required this.categoryName,
    required this.subCategories,
  });

  factory SubCategoryAdminResponse.fromJson(Map<String, dynamic> json) {
    return SubCategoryAdminResponse(
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      subCategories: (json['subCategories'] as List<dynamic>?)
              ?.map((item) => SubCategoryAdminModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'subCategories': subCategories.map((sub) => sub.toJson()).toList(),
    };
  }
}

