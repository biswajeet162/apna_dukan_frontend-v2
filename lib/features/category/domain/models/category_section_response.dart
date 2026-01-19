// Category Section Response Model
import 'category.dart';

class CategorySectionResponse {
  final String sectionId;
  final String sectionCode;
  final List<Category> categories;

  CategorySectionResponse({
    required this.sectionId,
    required this.sectionCode,
    required this.categories,
  });

  factory CategorySectionResponse.fromJson(Map<String, dynamic> json) {
    return CategorySectionResponse(
      sectionId: json['sectionId'] as String,
      sectionCode: json['sectionCode'] as String,
      categories: (json['categories'] as List<dynamic>?)
              ?.map((item) => Category.fromJson(item as Map<String, dynamic>))
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


