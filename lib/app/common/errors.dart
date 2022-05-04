
abstract class Error {
  Error(this.message, this.code);
  String message;
  String code;
}



class AuthErrors implements Error {
  AuthErrors(this.code, this.message);

  @override
  String code;

  @override
  String message;

  static AuthErrors userAlreadyLoggedIn = AuthErrors(
      "300", "An user is already logged In.Please sign-out before proceeding");
}

