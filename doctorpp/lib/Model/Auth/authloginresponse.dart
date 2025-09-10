class AuthLoginResponse {
  String message;
  bool success;  // Change the type from String to bool

  AuthLoginResponse({
    required this.message,
    required this.success,
  });

  factory AuthLoginResponse.fromJson(Map<String, dynamic> json) {
    return AuthLoginResponse(
      message: json['message'],
      success: json['success'], // This will now correctly handle a boolean
    );
  }
}
