import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_note_app/app/common/errors.dart';
import 'package:the_note_app/app/common/result.dart';
import 'package:the_note_app/app/handlers/auth/cognito_auth_handler.dart';

class UpdatePasswordController extends GetxController {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newConfirmedPasswordController =
      TextEditingController();
  CognitoAuthHandler _cognitoAuthHandler = Get.find();

  late String username;
  late String confirmationCode;

  String? validateFields(String? _) {
    return newPasswordController.text !=
            newConfirmedPasswordController.text
        ? "Both the passwords need to match"
        : null;
  }

  Future<Result<void, AuthError>> confirmInputPasswordWithConfirmationCode() {
    return _cognitoAuthHandler.verifyAndResetPassword(
        username, newPasswordController.text, confirmationCode);
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
