import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_note_app/app/common/errors.dart';
import 'package:the_note_app/app/common/result.dart';
import 'package:the_note_app/app/handlers/auth/auth_handler.dart';
import 'package:the_note_app/app/handlers/auth/cognito_auth_handler.dart';

class LoginController extends GetxController {
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

  String get inputEmailID => emailEditingController.text;
  String get inputPassword => passwordEditingController.text;

  late CognitoAuthHandler _cognitoAuthHandler = Get.find();

  var isNewUser = false.obs;

  Future<Result<AuthStatus, AuthError>> loginUserWithInputs() async {
    return this.isNewUser.value
        ? await _cognitoAuthHandler.signUp(
            emailEditingController.text, passwordEditingController.text)
        : await _cognitoAuthHandler.signIn(
            emailEditingController.text, passwordEditingController.text);
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
  void onClose() {
    this.emailEditingController.dispose();
    this.passwordEditingController.dispose();
  }
}
