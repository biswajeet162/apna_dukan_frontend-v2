// User Profile Response Model
class UserProfileResponse {
  final String userId;
  final String name;
  final String? email;
  final String? phone;
  final bool emailVerified;
  final bool phoneVerified;
  final String role;

  UserProfileResponse({
    required this.userId,
    required this.name,
    this.email,
    this.phone,
    required this.emailVerified,
    required this.phoneVerified,
    required this.role,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      userId: json['userId']?.toString() ?? json['userId'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      emailVerified: json['emailVerified'] as bool? ?? false,
      phoneVerified: json['phoneVerified'] as bool? ?? false,
      role: json['role']?.toString() ?? json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      'emailVerified': emailVerified,
      'phoneVerified': phoneVerified,
      'role': role,
    };
  }
}

