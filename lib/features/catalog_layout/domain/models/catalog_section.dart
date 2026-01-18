// Catalog Section Model
class CatalogSection {
  final String sectionId;
  final String sectionCode;
  final String title;
  final String? description;
  final LayoutType? layoutType;
  final ScrollType? scrollType;
  final int displayOrder;
  final bool enabled;
  final bool personalized;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CatalogSection({
    required this.sectionId,
    required this.sectionCode,
    required this.title,
    this.description,
    this.layoutType,
    this.scrollType,
    required this.displayOrder,
    required this.enabled,
    required this.personalized,
    this.createdAt,
    this.updatedAt,
  });

  factory CatalogSection.fromJson(Map<String, dynamic> json) {
    return CatalogSection(
      sectionId: json['sectionId'] as String,
      sectionCode: json['sectionCode'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      layoutType: json['layoutType'] != null
          ? LayoutType.fromString(json['layoutType'] as String)
          : null,
      scrollType: json['scrollType'] != null
          ? ScrollType.fromString(json['scrollType'] as String)
          : null,
      displayOrder: json['displayOrder'] as int,
      enabled: json['enabled'] as bool,
      personalized: json['personalized'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sectionId': sectionId,
      'sectionCode': sectionCode,
      'title': title,
      'description': description,
      'layoutType': layoutType?.value,
      'scrollType': scrollType?.value,
      'displayOrder': displayOrder,
      'enabled': enabled,
      'personalized': personalized,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

enum LayoutType {
  singleRow('SINGLE_ROW'),
  twoRow('TWO_ROW'),
  threeRow('THREE_ROW'),
  fourRow('FOUR_ROW');

  final String value;
  const LayoutType(this.value);

  static LayoutType? fromString(String? value) {
    if (value == null) return null;
    return LayoutType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => LayoutType.singleRow,
    );
  }
}

enum ScrollType {
  horizontal('HORIZONTAL');

  final String value;
  const ScrollType(this.value);

  static ScrollType? fromString(String? value) {
    if (value == null) return null;
    return ScrollType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ScrollType.horizontal,
    );
  }
}

