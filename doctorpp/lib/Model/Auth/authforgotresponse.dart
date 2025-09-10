class Authforgotresponse {
  String status;
  String message;

  Authforgotresponse({required this.status, required this.message});

  // Factory constructor to create an instance from JSON
  factory Authforgotresponse.fromJson(Map<String, dynamic> json) {
    return Authforgotresponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
    );
  }
}
