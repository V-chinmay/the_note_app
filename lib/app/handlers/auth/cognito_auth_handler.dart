import 'dart:ffi';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_flutter/categories/amplify_categories.dart';
import 'package:get/get.dart';
import 'package:the_note_app/app/common/amplifyconfiguration.dart';
import 'package:the_note_app/app/common/errors.dart';
import 'package:the_note_app/app/common/result.dart';

import 'auth_handler.dart';

abstract class CognitoAuthHandlerInterface extends AuthHandlerInterface {
  Future<Result<void, AuthError>> resendSignUpConfirmationCode(String emailID);
  Future<Result<void, AuthError>> verifyAndResetPassword(
      String emailID, String newPassword, String confirmationCode);
  Future<Result<AuthStatus, AuthError>> verifyUserForSignUp(
      String emailID, String verificationCode);
  Future<Result<void, AuthError>> logOut();
}

class CognitoAuthHandler implements CognitoAuthHandlerInterface {
  CognitoAuthHandler(this.cognitoAuthCategory);
  late AuthCategory cognitoAuthCategory;

  AuthUser? _cognitoAuthUser;
  CognitoAuthSession? _cognitoAuthSession;

  String? get userPoolAccessToken =>
      _cognitoAuthSession?.userPoolTokens?.accessToken;

  String? get userPoolIdToken => _cognitoAuthSession?.userPoolTokens?.idToken;

  String? get currentAuthorizedUserID => _cognitoAuthUser?.userId;
  String? get currentAuthorizedUserName => _cognitoAuthUser?.username;

  initialise() async {
    if (!Amplify.isConfigured) {
      await Amplify.addPlugins([
        // AmplifyAPI(),
        AmplifyAuthCognito()
      ]);
      await Amplify.configure(cognitoConfig);
    }
    try {
      _cognitoAuthUser = await cognitoAuthCategory.getCurrentUser();
    } catch (error) {
      _cognitoAuthUser = null;
      print("Failed to get current user ${error}");
    }

    try {
      _cognitoAuthSession = (await cognitoAuthCategory.fetchAuthSession(
              options: CognitoSessionOptions(getAWSCredentials: true)))
          as CognitoAuthSession;
    } catch (error) {
      _cognitoAuthSession = null;
      print("Failed to get current auth session with $error");
    }
  }

  @override
  AuthStatus get authStatus => (_cognitoAuthSession?.isSignedIn ?? false)
      ? AuthStatus.Authorized
      : AuthStatus.UnAuthorized;

  @override
  Future<Result<void, AuthError>> resetPassword(String emailID) async {
    Result<void, AuthError> resetPasswordAuthResult;
    try {
      ResetPasswordResult resetPasswordResult =
          await this.cognitoAuthCategory.resetPassword(username: emailID);
      resetPasswordAuthResult = SuccessResult(null);
    } on AuthException catch (error) {
      final cognitoAuthError = AuthError.fromCognitoException(error);
      resetPasswordAuthResult = FailureResult(
          cognitoAuthError == AuthError.unknown
              ? AuthError("400", error.message)
              : cognitoAuthError);
    }
    return resetPasswordAuthResult;
  }

  @override
  Future<Result<AuthStatus, AuthError>> signIn(String emailID, String password,
      {String? username}) async {
    Result<AuthStatus, AuthError> authAttemptStatus;
    try {
      if (this.authStatus == AuthStatus.Authorized)
        throw AuthError.userAlreadyLoggedIn;

      SignInResult signInResult = await this
          .cognitoAuthCategory
          .signIn(username: emailID, password: password);

      authAttemptStatus = signInResult.isSignedIn
          ? SuccessResult(AuthStatus.Authorized)
          : FailureResult(AuthError.unknown);
      await initialise();
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
      if (this.authStatus == AuthStatus.Authorized)
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
  Future<Result<AuthStatus, AuthError>> verifyUserForSignUp(
      String emailID, String verificationCode) async {
    Result<AuthStatus, AuthError> authAttemptResult;
    try {
      if (this.authStatus == AuthStatus.Authorized)
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

  @override
  Future<Result<Null, AuthError>> resendSignUpConfirmationCode(
      String emailID) async {
    Result<Null, AuthError> resendAuthCodeResult;

    try {
      await cognitoAuthCategory.resendSignUpCode(username: emailID);
      resendAuthCodeResult = SuccessResult(null);
    } on AuthException catch (error) {
      final cognitoError = AuthError.fromCognitoException(error);
      resendAuthCodeResult = FailureResult(cognitoError == AuthError.unknown
          ? AuthError("400", error.message)
          : cognitoError);
    }

    return resendAuthCodeResult;
  }

  @override
  Future<Result<void, AuthError>> verifyAndResetPassword(
      String emailID, String newPassword, String confirmationCode) async {
    Result<void, AuthError> verifyAndResetPasswordResult;
    try {
      await cognitoAuthCategory.confirmResetPassword(
          username: emailID,
          newPassword: newPassword,
          confirmationCode: confirmationCode);
      verifyAndResetPasswordResult = SuccessResult(null);
    } on AuthException catch (error) {
      final cognitoError = AuthError.fromCognitoException(error);
      verifyAndResetPasswordResult = FailureResult(
          cognitoError == AuthError.unknown
              ? AuthError("400", error.message)
              : cognitoError);
    }

    return verifyAndResetPasswordResult;
  }

  @override
  Future<Result<void, AuthError>> logOut() async {
    Result<void, AuthError> logOutResult;

    try {
      await cognitoAuthCategory.signOut();
      await initialise();
      logOutResult = SuccessResult(null);
    } on AuthException catch (error) {
      final cognitoError = AuthError.fromCognitoException(error);
      logOutResult = FailureResult(cognitoError == AuthError.unknown
          ? AuthError("400", error.message)
          : cognitoError);
    }

    return logOutResult;
  }
}
