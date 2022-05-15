import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:the_note_app/app/common/errors.dart';
import 'package:the_note_app/app/common/result.dart';
import 'package:the_note_app/app/common/views/app_loading_view.dart';
import 'package:the_note_app/app/common/views/info_snackbar_view.dart';
import 'package:the_note_app/app/common/views/input_field.dart';
import 'package:the_note_app/app/modules/user_verification/controllers/user_verification_controller.dart';
import 'package:the_note_app/app/routes/app_pages.dart';
import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  GlobalKey<FormState> _formStateKey = GlobalKey();

  void onResetPasswordPressed() async {
    if (_formStateKey.currentState?.validate() ?? false) {
      Result<void, AuthError> resetPasswordResult = await Get.showOverlay(
          loadingWidget: AppLoadingView(),
          asyncFunction: this.controller.sendResetPasswordLinkForInputEmailID);
      if (resetPasswordResult is SuccessResult) {
        Get.showSnackbar(InfoSnackBar(
          "Successfully sent the confirmation code to the email address!",
        ));
        Get.toNamed(Routes.USER_VERIFICATION,arguments: {
          "userVerificationType":UserVerificationType.UpdatePassword,
          "username":this.controller.inputEmailId
        });
      } else if (resetPasswordResult is FailureResult) {
        Get.showSnackbar(InfoSnackBar(
          resetPasswordResult.error?.message ?? "Failed to send confirmation code to the email address!",
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
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text(
              "Enter the emailID to which the confirmation code needs to sent"),
          Form(
            key: _formStateKey,
            child: UserInfoField(
              UserInfoFieldType.email,
              textEditingController: controller.emailIDEditingController,
            ),
          ),
          ElevatedButton(
              onPressed: onResetPasswordPressed,
              child: Text("Send password confirmation code"))
        ]),
      ),
    );
  }
}
