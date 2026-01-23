// Update Section Request Model
import '../../domain/models/catalog_section.dart';

class UpdateSectionRequest {
  final String? sectionCode;
  final String? title;
  final String? description;
  final LayoutType? layoutType;
  final ScrollType? scrollType;
  final int? displayOrder;
  final bool? enabled;
  final bool? personalized;

  UpdateSectionRequest({
    this.sectionCode,
    this.title,
    this.description,
    this.layoutType,
    this.scrollType,
    this.displayOrder,
    this.enabled,
    this.personalized,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (sectionCode != null) json['sectionCode'] = sectionCode;
    if (title != null) json['title'] = title;
    if (description != null) json['description'] = description;
    if (layoutType != null) json['layoutType'] = layoutType!.value;
    if (scrollType != null) json['scrollType'] = scrollType!.value;
    if (displayOrder != null) json['displayOrder'] = displayOrder;
    if (enabled != null) json['enabled'] = enabled;
    if (personalized != null) json['personalized'] = personalized;
    return json;
  }
}

