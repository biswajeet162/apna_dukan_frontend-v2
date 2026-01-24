// Bulk Update Product Group Request Model
import 'bulk_update_product_group_item.dart';

class BulkUpdateProductGroupRequest {
  final List<BulkUpdateProductGroupItem> productGroups;

  BulkUpdateProductGroupRequest({
    required this.productGroups,
  });

  Map<String, dynamic> toJson() {
    return {
      'productGroups': productGroups.map((item) => item.toJson()).toList(),
    };
  }
}

