import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:the_note_app/app/common/amplifyconfiguration.dart';
import 'package:the_note_app/app/common/errors.dart';
import 'package:the_note_app/app/common/result.dart';
import 'package:the_note_app/app/common/views/input_field.dart';
import 'package:the_note_app/app/handlers/auth/auth_handler.dart';
import 'package:the_note_app/app/modules/user_verification/controllers/user_verification_controller.dart';
import 'package:the_note_app/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  GlobalKey<FormState> _credsFormKey = GlobalKey();

  Form get _userAuthDetailsInputForm => Form(
      key: this._credsFormKey,
      child: Column(
        children: [
          UserInfoField(
            UserInfoFieldType.email,
            textEditingController: this.controller.emailEditingController,
          ),
          SizedBox(
            height: 10,
          ),
          UserInfoField(
            UserInfoFieldType.password,
            textEditingController: this.controller.passwordEditingController,
            passwordPolicyRegex: RegExp(AWS_PASSWORD_POLICY_REGEX),
          )
        ],
      ));

  Widget get _loginButton => ConstrainedBox(
        constraints: BoxConstraints(minWidth: double.infinity),
        child: ElevatedButton(
          onPressed: this.onLoginPressed,
          child: Text(this.controller.isNewUser.value ? "Register" : "Login"),
        ),
      );

  TextButton get _forgotPasswordButton => TextButton(
      onPressed: onForgotPasswordPressed,
      child: Text(
        "Forgot Password",
        style: TextStyle(color: Colors.orange),
      ));

  Widget get _signUpButton => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              this.controller.isNewUser.value
                  ? "Already have an account?"
                  : "New to Notes?",
              style: TextStyle(color: Colors.white)),
          SizedBox(
            width: 10,
          ),
          TextButton(
            onPressed: onRegisterAccountPressed,
            child: Text(
              this.controller.isNewUser.value ? "Login" : "Register",
              style: TextStyle(color: Colors.orange),
            ),
          )
        ],
      );

  void onForgotPasswordPressed() {
    Get.toNamed(Routes.RESET_PASSWORD);
  }

  void onLoginPressed() async {
    if (this._credsFormKey.currentState?.validate() ?? false) {
      FocusManager.instance.primaryFocus?.unfocus();
      Result<AuthStatus, AuthError> result = await Get.showOverlay(
          asyncFunction: this.controller.loginUserWithInputs);

      if (result is SuccessResult) {
        if (result.data == AuthStatus.AuthorizedButNeedsVerification) {
          bool isVerificationSuccessful =
              await Get.toNamed(Routes.USER_VERIFICATION, arguments: {
            "username": this.controller.inputEmailID,
            "userVerificationType" : UserVerificationType.SignUp
          }); //successfully signed in but need verification go to signup verification screen
          if (!isVerificationSuccessful) {
            Get.showSnackbar(GetSnackBar(
              message: "User verification failed.Please try again!",
            ));
            return;
          }
        }
        Get.offAllNamed(Routes.HOME);
        //successfully signed in go to the home screen
      } else if (result is FailureResult) {
        if (result.error == AuthError.userNotConfirmed) {
          Get.toNamed(Routes.USER_VERIFICATION, arguments: {
            "username": this.controller.inputEmailID,
            "userVerificationType" : UserVerificationType.SignUp
          }); //user not confirmed go to verification screen
          return;
        }
        Get.showSnackbar(GetSnackBar(
          message: result.error!.message,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        ));
      }
    }
  }

  void onRegisterAccountPressed() {
    controller.isNewUser.toggle();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        appBar: AppBar(
          title: Text(
            this.controller.isNewUser.value ? "Sign-Up" : "Login",
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            _userAuthDetailsInputForm,
            if (!this.controller.isNewUser.value)
              Align(
                  alignment: Alignment.centerRight,
                  child: _forgotPasswordButton),
            SizedBox(
              height: 20,
            ),
            _loginButton,
            _signUpButton
          ]),
        )));
  }
}
