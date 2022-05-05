import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/categories/amplify_categories.dart';
import 'package:get/get.dart';
import 'package:the_note_app/app/common/errors.dart';
import 'package:the_note_app/app/common/result.dart';

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
  Future<Result<AuthStatus, AuthError>> signIn(String emailID, String password,
      {String? username}) async {
    Result<AuthStatus, AuthError> authAttemptStatus;
    try {
      if (await this.authStatus == AuthStatus.Authorized)
        throw AuthError.userAlreadyLoggedIn;

      SignInResult signInResult = await this
          .cognitoAuthCategory
          .signIn(username: emailID, password: password);

      authAttemptStatus = signInResult.isSignedIn
          ? SuccessResult(AuthStatus.Authorized)
          : FailureResult(AuthError.unknown);
    } on AuthException catch (error) {
      AuthError authError = AuthError.fromCognitoException(error);
      authAttemptStatus = FailureResult(authError == AuthError.unknown
          ? AuthError("300", error.message)
          : authError);
    }

    return authAttemptStatus;
  }

  @override
  Future<bool> signOut() async {
    return true;
  }

  @override
  Future<Result<AuthStatus, AuthError>> signUp(String emailID, String password,
      {String? username}) async {
    Result<AuthStatus, AuthError> authAttemptStatus;
    try {
      if (await this.authStatus == AuthStatus.Authorized)
        throw AuthError.userAlreadyLoggedIn;

      SignUpResult signUpResult = await this.cognitoAuthCategory.signUp(
          username: emailID,
          password: password,
          options: CognitoSignUpOptions(userAttributes: {"email": emailID}));

      authAttemptStatus = signUpResult.isSignUpComplete
          ? SuccessResult(AuthStatus.Authorized)
          : FailureResult(AuthError.unknown);
      if (signUpResult.isSignUpComplete &&
          signUpResult.nextStep.signUpStep != null) {
        authAttemptStatus =
            SuccessResult(AuthStatus.AuthorizedButNeedsVerification);
      }
    } on AuthException catch (error) {
      AuthError authError = AuthError.fromCognitoException(error);
      authAttemptStatus = FailureResult(authError == AuthError.unknown
          ? AuthError("300", error.message)
          : authError);
    }

    return authAttemptStatus;
  }

  @override
  Future<Result<AuthStatus, AuthError>> verifyUser(
      String emailID, String verificationCode) async {
    Result<AuthStatus, AuthError> authAttemptResult;
    try {
      if (await this.authStatus == AuthStatus.Authorized)
        throw AuthError.userAlreadyLoggedIn;
      SignUpResult signUpResult = await cognitoAuthCategory.confirmSignUp(
          username: emailID, confirmationCode: verificationCode);
      authAttemptResult = signUpResult.isSignUpComplete
          ? SuccessResult(AuthStatus.Authorized)
          : FailureResult(AuthError.unknown);
    } on AuthException catch (error) {
      AuthError authError = AuthError.fromCognitoException(error);
      authAttemptResult = FailureResult(authError == AuthError.unknown
          ? AuthError("300", error.message)
          : authError);
    }

    return authAttemptResult;
  }
}
