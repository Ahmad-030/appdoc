
class Authforgotrequest{
  final String email;

  Authforgotrequest({
    required this.email

  });

  Map<String , dynamic> tojson(){
    return {
      'email': email,

    };
  }
}