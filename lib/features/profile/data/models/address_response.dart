// Address Response Model
class AddressResponse {
  final String addressId;
  final String name;
  final String phone;
  final String line1;
  final String? line2;
  final String city;
  final String state;
  final String pincode;
  final String country;
  final String type;
  final bool isDefault;
  final String? createdAt;

  AddressResponse({
    required this.addressId,
    required this.name,
    required this.phone,
    required this.line1,
    this.line2,
    required this.city,
    required this.state,
    required this.pincode,
    required this.country,
    required this.type,
    required this.isDefault,
    this.createdAt,
  });

  factory AddressResponse.fromJson(Map<String, dynamic> json) {
    return AddressResponse(
      addressId: json['addressId']?.toString() ?? json['addressId'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      line1: json['line1'] as String,
      line2: json['line2'] as String?,
      city: json['city'] as String,
      state: json['state'] as String,
      pincode: json['pincode'] as String,
      country: json['country'] as String? ?? 'India',
      type: json['type']?.toString() ?? json['type'] as String,
      isDefault: json['isDefault'] as bool? ?? false,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'addressId': addressId,
      'name': name,
      'phone': phone,
      'line1': line1,
      if (line2 != null) 'line2': line2,
      'city': city,
      'state': state,
      'pincode': pincode,
      'country': country,
      'type': type,
      'isDefault': isDefault,
      if (createdAt != null) 'createdAt': createdAt,
    };
  }

  String get fullAddress {
    final parts = [line1];
    if (line2 != null && line2!.isNotEmpty) {
      parts.add(line2!);
    }
    parts.add('$city, $state');
    parts.add(pincode);
    parts.add(country);
    return parts.join(', ');
  }
}

