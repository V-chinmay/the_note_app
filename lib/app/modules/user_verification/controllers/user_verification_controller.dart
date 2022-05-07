import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:the_note_app/app/common/errors.dart';
import 'package:the_note_app/app/common/result.dart';
import 'package:the_note_app/app/handlers/auth/auth_handler.dart';
import 'package:the_note_app/app/handlers/auth/cognito_auth_handler.dart';

enum UserVerificationType { SignUp, UpdatePassword }

class UserVerificationController extends GetxController {
  TextEditingController verificationCodeController = TextEditingController();

  String get inputConfirmationCode => verificationCodeController.text;
  String? userEmailID;

  late UserVerificationType userVerificationType;

  late CognitoAuthHandler _cognitoAuthHandler = Get.find();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  Future<Result<AuthStatus, AuthError>> verifyUserWithInputCode() {
    return _cognitoAuthHandler.verifyUserForSignUp(
        this.userEmailID!, verificationCodeController.text);
  }

  Future<Result<Null, AuthError>> resendSignUpConfirmationCode() {
    return _cognitoAuthHandler.resendSignUpConfirmationCode(this.userEmailID!);
  }

  @override
  void onClose() {}
}
