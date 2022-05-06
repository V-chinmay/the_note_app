import 'package:the_note_app/app/common/errors.dart';
import 'package:the_note_app/app/common/result.dart';

enum AuthStatus { Authorized, UnAuthorized, AuthorizedButNeedsVerification }

abstract class AuthHandler {
  Future<AuthStatus> get authStatus;
  Future<Result<AuthStatus, AuthError>> signIn(String emailID, String password,
      {String? username});
  Future<Result<AuthStatus, AuthError>> signUp(String emailID, String password,
      {String? username});
  Future<Result<AuthStatus, AuthError>> verifyUser(String emailID,String verificationCode);
  Future<Result<void, AuthError>> resendVerificationCode(String emailID);
  Future<bool> signOut();
  Future<Result<void, AuthError>> resetPassword(String emailID);
}
