// Bulk Update SubCategory Request Model
import 'bulk_update_subcategory_item.dart';

class BulkUpdateSubCategoryRequest {
  final List<BulkUpdateSubCategoryItem> subCategories;

  BulkUpdateSubCategoryRequest({
    required this.subCategories,
  });

  Map<String, dynamic> toJson() {
    return {
      'subCategories': subCategories.map((item) => item.toJson()).toList(),
    };
  }
}

