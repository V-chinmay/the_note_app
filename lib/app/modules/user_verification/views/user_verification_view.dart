import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:the_note_app/app/common/errors.dart';
import 'package:the_note_app/app/common/result.dart';
import 'package:the_note_app/app/handlers/auth/auth_handler.dart';

import '../controllers/user_verification_controller.dart';

class UserVerificationView extends GetView<UserVerificationController> {
  PinCodeTextField get _pinCodeTextField => PinCodeTextField(
      appContext: Get.context!,
      controller: this.controller.verificationCodeController,
      length: 6,
      onChanged: (_) => null);

  Widget get _verifyButton => Container(
        constraints: BoxConstraints(minWidth: double.infinity),
        child: ElevatedButton(
          onPressed: this.onVerifyPressed,
          child: Text("Verify"),
        ),
      );
  Widget get _resendConfirmationCodeButton => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Didn't get a confirmation code?",
          ),
          TextButton(
              onPressed: onResendCodePressed, child: Text("Resend Code")),
        ],
      );

  void onVerifyPressed() async {
    Result<AuthStatus, AuthError> verificationResult = await Get.showOverlay(
        loadingWidget: CircularProgressIndicator(),
        asyncFunction: controller.verifyUserWithInputCode);
    if (verificationResult is SuccessResult) {
      Get.back(result: true);
    } else if (verificationResult is FailureResult) {
      Get.showSnackbar(GetSnackBar(
        message: verificationResult.error?.message ??
            "Failed to verify the user.Please try again",
      ));
    }
  }

  void onResendCodePressed() async {
    Result<Null, AuthError> resendConfirmationCodeResult =
        await Get.showOverlay(
            loadingWidget: SizedBox.fromSize(
                size: Size.square(48), child: CircularProgressIndicator()),
            asyncFunction: this.controller.resendConfirmationCode);
    if (resendConfirmationCodeResult is SuccessResult) {
      Get.showSnackbar(GetSnackBar(
        duration: Duration(seconds: 1),
        message: "Sent an confirmation code to your email-ID",
      ));
    } else if (resendConfirmationCodeResult is FailureResult) {
      Get.showSnackbar(GetSnackBar(
        duration: Duration(seconds: 1),
        message: resendConfirmationCodeResult.error?.message ??
            "Failed to send confirmation code to your email-ID",
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
          body: Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Enter the code sent to ${this.controller.userEmailID}"),
                _pinCodeTextField,
                _verifyButton,
                _resendConfirmationCodeButton
              ],
            ),
          )),
    );
  }
}
