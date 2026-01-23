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
    return AuthResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      type: json['type'] as String? ?? 'Bearer',
      userId: json['userId']?.toString() ?? json['userId'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      role: json['role']?.toString() ?? json['role'] as String,
    );
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



