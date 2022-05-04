import 'package:flutter/material.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:get/state_manager.dart';

enum UserInfoFieldType { email, password }

class UserInfoField extends StatelessWidget {
  UserInfoField(this.userInfoFieldType,
      {Key? key,
      this.textEditingController,
      this.onInputSubmitted,
      this.passwordPolicyRegex})
      : super(key: key);

  final UserInfoFieldType userInfoFieldType;
  void Function(String)? onInputSubmitted;
  RegExp? passwordPolicyRegex;
  RxBool _isPasswordVisible = false.obs;

  TextEditingController? textEditingController;

  String? Function(String?) _inputValidator(
      UserInfoFieldType userInfoFieldType) {
    switch (userInfoFieldType) {
      case UserInfoFieldType.email:
        return (emailInput) => emailInput != null
            ? !GetUtils.isEmail(emailInput)
                ? "Enter an valid email address"
                : null
            : null;
      case UserInfoFieldType.password:
        return (passwordInput) => passwordInput != null
            ? (!(this.passwordPolicyRegex?.hasMatch(passwordInput) ?? (true)))
                ? "Password must have uppercase and special characters."
                : null
            : null;
      default:
        return (_) => null;
    }
  }

  final InputDecoration _commonInputDecoration = InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.red)));

  InputDecoration _inputDecoration(UserInfoFieldType userInfoFieldType) {
    switch (userInfoFieldType) {
      case UserInfoFieldType.email:
        return _commonInputDecoration.copyWith(
            hintText: "user@example.com", labelText: "Email-ID");
      case UserInfoFieldType.password:
        return _commonInputDecoration.copyWith(
            hintText: "password",
            labelText: "Password",
            suffixIcon: Obx(() => IconButton(
                onPressed: () {
                  this._isPasswordVisible.toggle();
                },
                icon: Icon(!this._isPasswordVisible.value
                    ? Icons.visibility
                    : Icons.visibility_off))));
      default:
        return _commonInputDecoration;
    }
  }

  @override
  Widget build(BuildContext context) {
    return this.userInfoFieldType == UserInfoFieldType.password
        ? Obx(
            () => TextFormField(
              validator: _inputValidator(this.userInfoFieldType),
              decoration: _inputDecoration(this.userInfoFieldType),
              controller: this.textEditingController,
              obscureText:
                  this.userInfoFieldType == UserInfoFieldType.password &&
                      !this._isPasswordVisible.value,
              onChanged: this.onInputSubmitted,
            ),
          )
        : TextFormField(
            validator: _inputValidator(this.userInfoFieldType),
            decoration: _inputDecoration(this.userInfoFieldType),
            controller: this.textEditingController,
            obscureText: this.userInfoFieldType == UserInfoFieldType.password,
            onChanged: this.onInputSubmitted,
          );
  }
}
