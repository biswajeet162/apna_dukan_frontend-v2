// Signup Request Model
class SignupRequest {
  final String name;
  final String? email;
  final String? phone;
  final String password;

  SignupRequest({
    required this.name,
    this.email,
    this.phone,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (email != null && email!.isNotEmpty) 'email': email,
      if (phone != null && phone!.isNotEmpty) 'phone': phone,
      'password': password,
    };
  }
}



