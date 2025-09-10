class AuthSignupResponse {
  bool success;
  String message;
  String token;
  User result;

  AuthSignupResponse({
    required this.success,
    required this.message,
    required this.token,
    required this.result,
  });

  // Factory constructor to create an instance from JSON
  factory AuthSignupResponse.fromJson(Map<String, dynamic> json) {
    return AuthSignupResponse(
      success: json['success'],
      message: json['message'],
      token: json['Token'],
      result: User.fromJson(json['result']),
    );
  }
}

class User {
  String firstName;
  String lastName;
  String email;
  String password;
  String userType;
  String phoneNo;
  String id;
  String createdAt;
  String updatedAt;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.userType,
    required this.phoneNo,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create an instance from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      password: json['password'],
      userType: json['userType'],
      phoneNo: json['phoneNo'],
      id: json['_id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
