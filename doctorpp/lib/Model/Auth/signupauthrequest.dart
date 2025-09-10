class SignupAuthRequest {
  String firstName;
  String lastName;
  String email;
  String password;
  String phoneNo;

  SignupAuthRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phoneNo,
  });

  // Convert to JSON (for making API calls)
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'phoneNo': phoneNo,
    };
  }
}
