import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

abstract class Error {
  Error(this.message, this.code);
  String message;
  String code;
}

class AuthError implements Error {
  AuthError(this.code, this.message);

  @override
  String code;

  @override
  String message;

  static AuthError userAlreadyLoggedIn = AuthError(
      "300", "An user is already logged In.Please sign-out before proceeding.");

  static AuthError userNotConfirmed =
      AuthError("300", "User not confirmed in the system.");

  static AuthError userNotFound = AuthError("300", "User not found.");

  static AuthError unknown = AuthError("300", "Unknown Reason.");

  factory AuthError.fromCognitoException(AuthException exception) {
    switch (exception.runtimeType) {
      case UserNotConfirmedException:
        return AuthError.userNotConfirmed;
      case UserNotFoundException:
        return AuthError.userNotFound;
      default:
        return AuthError.unknown;
    }
  }
}
