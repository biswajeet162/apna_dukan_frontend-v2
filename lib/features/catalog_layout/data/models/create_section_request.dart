// Create Section Request Model
import '../../domain/models/catalog_section.dart';

class CreateSectionRequest {
  final String sectionCode;
  final String title;
  final String? description;
  final LayoutType layoutType;
  final ScrollType scrollType;
  final int displayOrder;
  final bool enabled;
  final bool personalized;

  CreateSectionRequest({
    required this.sectionCode,
    required this.title,
    this.description,
    required this.layoutType,
    required this.scrollType,
    required this.displayOrder,
    this.enabled = true,
    this.personalized = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'sectionCode': sectionCode.toUpperCase(), // Ensure uppercase
      'title': title,
      if (description != null && description!.isNotEmpty) 'description': description,
      'layoutType': layoutType.value,
      'scrollType': scrollType.value,
      'displayOrder': displayOrder,
      'enabled': enabled,
      'personalized': personalized,
    };
  }
}

