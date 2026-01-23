// Bulk Update Request Model
import 'bulk_update_item.dart';

class BulkUpdateRequest {
  final List<BulkUpdateItem> sections;

  BulkUpdateRequest({
    required this.sections,
  });

  Map<String, dynamic> toJson() {
    return {
      'sections': sections.map((item) => item.toJson()).toList(),
    };
  }
}

