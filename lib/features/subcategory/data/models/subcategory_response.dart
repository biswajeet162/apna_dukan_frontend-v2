// SubCategory Response Model
import 'subcategory_model.dart';

class SubCategoryResponse {
  final String categoryId;
  final String categoryName;
  final List<SubCategoryModel> subCategories;

  SubCategoryResponse({
    required this.categoryId,
    required this.categoryName,
    required this.subCategories,
  });

  factory SubCategoryResponse.fromJson(Map<String, dynamic> json) {
    return SubCategoryResponse(
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      subCategories: (json['subCategories'] as List<dynamic>?)
              ?.map((item) => SubCategoryModel.fromJson(item as Map<String, dynamic>))
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

