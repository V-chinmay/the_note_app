import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:the_note_app/app/common/input_field.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  GlobalKey<FormState> _formKey = GlobalKey();

  Form get _userAuthDetailsInputForm => Form(
      key: this._formKey,
      child: Column(
        children: [
          UserInfoField(UserInfoFieldType.email, (emailInput) => null),
          SizedBox(
            height: 10,
          ),
          UserInfoField(UserInfoFieldType.password, (passwordInput) => null)
        ],
      ));
  Widget get _loginButton => ConstrainedBox(
        constraints: BoxConstraints(minWidth: double.infinity),
        child: ElevatedButton(
          onPressed: () => this._formKey.currentState?.validate(),
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

  TextButton get _signUpButton => TextButton(
      onPressed: () => null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("New to Notes?", style: TextStyle(color: Colors.white)),
          SizedBox(
            width: 10,
          ),
          Text(
            "Register",
            style: TextStyle(color: Colors.orange),
          )
        ],
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Login',
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            _userAuthDetailsInputForm,
            Align(
                alignment: Alignment.centerRight, child: _forgotPasswordButton),
            SizedBox(
              height: 20,
            ),
            _loginButton,
            _signUpButton
          ]),
        ));
  }
}
