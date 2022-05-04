import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/categories/amplify_categories.dart';
import 'package:get/get.dart';
import 'package:the_note_app/app/common/errors.dart';

import 'auth_handler.dart';

class CognitoAuthHandler implements AuthHandler {
  CognitoAuthHandler(this.cognitoAuthCategory);
  late AuthCategory cognitoAuthCategory;

  @override
  Future<AuthStatus> get authStatus async =>
      (await cognitoAuthCategory.fetchAuthSession()).isSignedIn
          ? AuthStatus.Authorized
          : AuthStatus.UnAuthorized;

  @override
  Future<bool> resetPassword() {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }

  @override
  Future<AuthAttemptStatus> signIn(String emailID, String password,
      {String? username}) async {
    AuthAttemptStatus authAttemptStatus;
    try {
      if (await this.authStatus == AuthStatus.Authorized)
        throw AuthErrors.userAlreadyLoggedIn;

      SignInResult signInResult = await this
          .cognitoAuthCategory
          .signIn(username: emailID, password: password);

      authAttemptStatus = signInResult.isSignedIn
          ? AuthAttemptStatus(AuthStatus.Authorized)
          : AuthAttemptStatus(AuthStatus.UnAuthorized,
              authAttemptFailureReason: "Unknown Reason.");
    } on AuthException catch (error) {
      authAttemptStatus = AuthAttemptStatus(AuthStatus.UnAuthorized,
          authAttemptFailureReason: error.message);
    }

    return authAttemptStatus;
  }

  @override
  Future<bool> signOut() async {
    return true;
  }

  @override
  Future<AuthAttemptStatus> signUp(String emailID, String password,
      {String? username}) async {
    AuthAttemptStatus authAttemptStatus;
    try {
      if (await this.authStatus == AuthStatus.Authorized)
        throw AuthErrors.userAlreadyLoggedIn;

      SignUpResult signUpResult = await this.cognitoAuthCategory.signUp(
          username: emailID,
          password: password,
          options: CognitoSignUpOptions(userAttributes: {"email": emailID}));
        
      authAttemptStatus = signUpResult.isSignUpComplete
          ? AuthAttemptStatus(AuthStatus.Authorized)
          : AuthAttemptStatus(AuthStatus.UnAuthorized,
              authAttemptFailureReason: "Unknown Reason.");
      if (signUpResult.isSignUpComplete &&
          signUpResult.nextStep.signUpStep != null) {
        authAttemptStatus =
            AuthAttemptStatus(AuthStatus.AuthorizedButNeedsVerification);
      }
    } on AuthException catch (error) {
      authAttemptStatus = AuthAttemptStatus(AuthStatus.UnAuthorized,
          authAttemptFailureReason: error.message);
    }

    return authAttemptStatus;
  }
}
