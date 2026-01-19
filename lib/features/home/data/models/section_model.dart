// Section Model for Home
class SectionModel {
  final String sectionId;
  final String sectionCode;
  final String name;
  final String? description;
  final int displayOrder;
  final bool enabled;

  SectionModel({
    required this.sectionId,
    required this.sectionCode,
    required this.name,
    this.description,
    required this.displayOrder,
    required this.enabled,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(
      sectionId: json['sectionId'] as String,
      sectionCode: json['sectionCode'] as String,
      name: json['name'] as String? ?? json['title'] as String? ?? '',
      description: json['description'] as String?,
      displayOrder: json['displayOrder'] as int,
      enabled: json['enabled'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sectionId': sectionId,
      'sectionCode': sectionCode,
      'name': name,
      'description': description,
      'displayOrder': displayOrder,
      'enabled': enabled,
    };
  }
}

