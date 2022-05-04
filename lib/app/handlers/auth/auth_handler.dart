enum AuthStatus { Authorized, UnAuthorized, AuthorizedButNeedsVerification }

class AuthAttemptStatus {
  AuthAttemptStatus(this.authStatus,{this.authAttemptFailureReason});
  AuthStatus authStatus;
  String? authAttemptFailureReason;
}

abstract class AuthHandler {
  Future<AuthStatus> get authStatus;
  Future<AuthAttemptStatus> signIn(String emailID, String password,
      {String? username});
  Future<AuthAttemptStatus> signUp(String emailID, String password,
      {String? username});
  Future<bool> signOut();
  Future<bool> resetPassword();
}
