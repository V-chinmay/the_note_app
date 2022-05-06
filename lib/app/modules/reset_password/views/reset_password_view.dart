import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:the_note_app/app/common/errors.dart';
import 'package:the_note_app/app/common/result.dart';
import 'package:the_note_app/app/common/views/input_field.dart';
import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  GlobalKey<FormState> _formStateKey = GlobalKey();

  void onResetPasswordPressed() async {
    if (_formStateKey.currentState?.validate() ?? false) {
      Result<void, AuthError> resetPasswordResult = await Get.showOverlay(
          loadingWidget: SizedBox.fromSize(
              size: Size.square(48), child: CircularProgressIndicator()),
          asyncFunction: this.controller.sendResetPasswordLinkForInputEmailID);
      if (resetPasswordResult is SuccessResult) {
        Get.showSnackbar(GetSnackBar(
          message: "Successfully sent the reset link to the email address!",
        ));
      } else if (resetPasswordResult is FailureResult) {
        Get.showSnackbar(GetSnackBar(
          message: resetPasswordResult.error?.message ??
              "Failed to send resent link to the email address!",
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Reset Password",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          Text("Enter the emailID to which the reset link needs to sent"),
          Form(
            key: _formStateKey,
            child: UserInfoField(
              UserInfoFieldType.email,
              textEditingController: controller.emailIDEditingController,
            ),
          ),
          ElevatedButton(
              onPressed: onResetPasswordPressed,
              child: Text("Send password reset link"))
        ]),
      ),
    );
  }
}
