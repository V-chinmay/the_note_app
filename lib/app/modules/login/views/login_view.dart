import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:the_note_app/app/common/amplifyconfiguration.dart';
import 'package:the_note_app/app/common/views/input_field.dart';
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
          child: Text("Login"),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.orange)),
        ),
      );

  TextButton get _forgotPasswordButton => TextButton(
      onPressed: () => null,
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

  void onLoginPressed() {
    if (this._credsFormKey.currentState?.validate() ?? false) {
      this.controller.isNewUser.value
          ? this.controller.signUpWithInputs()
          : this.controller.signInWithInputs();
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
            if (this.controller.isNewUser.value)
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
