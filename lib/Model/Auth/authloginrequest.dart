class AuthLoginRequest {
  String email;
  String password;

  AuthLoginRequest({
    required this.email,
    required this.password,
  });

  Map<String , dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
