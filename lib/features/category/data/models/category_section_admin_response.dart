// Category Section Admin Response Model
import 'category_admin_model.dart';

class CategorySectionAdminResponse {
  final String sectionId;
  final String sectionCode;
  final List<CategoryAdminModel> categories;

  CategorySectionAdminResponse({
    required this.sectionId,
    required this.sectionCode,
    required this.categories,
  });

  factory CategorySectionAdminResponse.fromJson(Map<String, dynamic> json) {
    return CategorySectionAdminResponse(
      sectionId: json['sectionId'] as String,
      sectionCode: json['sectionCode'] as String,
      categories: (json['categories'] as List<dynamic>?)
              ?.map((item) => CategoryAdminModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sectionId': sectionId,
      'sectionCode': sectionCode,
      'categories': categories.map((cat) => cat.toJson()).toList(),
    };
  }
}

