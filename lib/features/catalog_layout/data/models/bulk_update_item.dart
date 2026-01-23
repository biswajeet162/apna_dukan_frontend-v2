// Bulk Update Item Model
class BulkUpdateItem {
  final String sectionId;
  final String? sectionCode;
  final String? title;
  final String? description;
  final String? layoutType;
  final String? scrollType;
  final int? displayOrder;
  final bool? enabled;
  final bool? personalized;

  BulkUpdateItem({
    required this.sectionId,
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
    final Map<String, dynamic> json = {'sectionId': sectionId};
    if (sectionCode != null) json['sectionCode'] = sectionCode;
    if (title != null) json['title'] = title;
    if (description != null) json['description'] = description;
    if (layoutType != null) json['layoutType'] = layoutType;
    if (scrollType != null) json['scrollType'] = scrollType;
    if (displayOrder != null) json['displayOrder'] = displayOrder;
    if (enabled != null) json['enabled'] = enabled;
    if (personalized != null) json['personalized'] = personalized;
    return json;
  }
}

