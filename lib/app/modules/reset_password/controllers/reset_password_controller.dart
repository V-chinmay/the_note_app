import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_note_app/app/common/errors.dart';
import 'package:the_note_app/app/common/result.dart';
import 'package:the_note_app/app/handlers/auth/cognito_auth_handler.dart';

class ResetPasswordController extends GetxController {
  TextEditingController emailIDEditingController = TextEditingController();

  late CognitoAuthHandler _cognitoAuthHandler = Get.find();

  Future<Result<void, AuthError>> sendResetPasswordLinkForInputEmailID() {
    return _cognitoAuthHandler
        .resetPassword(emailIDEditingController.text);
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
