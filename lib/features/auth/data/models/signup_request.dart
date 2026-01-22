// Signup Request Model
class SignupRequest {
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String password;

  SignupRequest({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'email': email,
      'password': password,
    };
  }
}

