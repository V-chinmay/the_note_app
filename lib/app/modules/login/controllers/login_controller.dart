import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_note_app/app/handlers/auth/auth_handler.dart';
import 'package:the_note_app/app/handlers/auth/cognito_auth_handler.dart';

class LoginController extends GetxController {
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

  late CognitoAuthHandler _cognitoAuthHandler = Get.find();

  var isNewUser = false.obs;

  void loginUserWithInputs() async {
    AuthStatus authStatus = await Get.showOverlay(
      asyncFunction: () async => this.isNewUser.value
          ? await _cognitoAuthHandler.signUp(
              emailEditingController.text, passwordEditingController.text)
          : await _cognitoAuthHandler.signIn(
              emailEditingController.text, passwordEditingController.text),
    );

    if (authStatus == AuthStatus.UnAuthorized) {
      Get.showSnackbar(GetSnackBar(
        message: "Failed to authorize with ",
      ));
    }
  }

  void signInWithInputs() async {
    bool isSignedIn = await Get.showOverlay(
      asyncFunction: () async => await _cognitoAuthHandler.signIn(
          emailEditingController.text, passwordEditingController.text),
    );

    if (!isSignedIn)
      Get.showSnackbar(GetSnackBar(
        message: "Failed to Log-In with provided credentials",
        snackPosition: SnackPosition.BOTTOM,
      ));
  }

  void signUpWithInputs() async {
    try {
      bool isSignedIn = await Get.showOverlay(
        asyncFunction: () async => await _cognitoAuthHandler.signUp(
            emailEditingController.text, passwordEditingController.text),
      );

      if (!isSignedIn)
        Get.showSnackbar(GetSnackBar(
          message: "Failed to Sign-Up with provided credentials",
          snackPosition: SnackPosition.BOTTOM,
        ));
    } catch (error) {
      print("Sign up failed with error ${error}");
    }
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
