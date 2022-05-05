import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:the_note_app/app/common/errors.dart';
import 'package:the_note_app/app/common/result.dart';
import 'package:the_note_app/app/handlers/auth/auth_handler.dart';

import '../controllers/user_verification_controller.dart';

class UserVerificationView extends GetView<UserVerificationController> {
  PinCodeTextField get pinCodeTextField => PinCodeTextField(
      appContext: Get.context!,
      controller: this.controller.verificationCodeController,
      length: 6,
      onChanged: (_) => null);

  Widget get _verifyButton => ConstrainedBox(
        constraints: BoxConstraints(minWidth: double.infinity),
        child: ElevatedButton(
          onPressed: this.onVerifyPressed,
          child: Text("Verify"),
        ),
      );

  void onVerifyPressed() async {
    Result<AuthStatus, AuthError> verificationResult = await Get.showOverlay(
        asyncFunction: controller.verifyUserWithInputCode);
    if (verificationResult is SuccessResult) {
      Get.back(result: true);
    } else if (verificationResult is FailureResult) {
      Get.showSnackbar(GetSnackBar(
        message: "Failed to verify the user.Please try again.",
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: false);
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "User Verification",
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Column(
            children: [
              Text("Email Verification"),
              Text("Enter the code sent to ${this.controller.userEmailID}"),
              pinCodeTextField,
            ],
          )),
    );
  }
}
