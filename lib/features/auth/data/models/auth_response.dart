// Auth Response Model
class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final String type;
  final String userId;
  final String name;
  final String? email;
  final String? phone;
  final String role;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.type,
    required this.userId,
    required this.name,
    this.email,
    this.phone,
    required this.role,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    try {
      return AuthResponse(
        accessToken: json['accessToken']?.toString() ?? '',
        refreshToken: json['refreshToken']?.toString() ?? '',
        type: json['type']?.toString() ?? 'Bearer',
        userId: json['userId']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        email: json['email']?.toString(),
        phone: json['phone']?.toString(),
        role: json['role']?.toString() ?? '',
      );
    } catch (e) {
      print('Error parsing AuthResponse: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'type': type,
      'userId': userId,
      'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      'role': role,
    };
  }
}



