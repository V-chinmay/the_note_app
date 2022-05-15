import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:the_note_app/app/common/errors.dart';
import 'package:the_note_app/app/common/result.dart';
import 'package:the_note_app/app/common/views/app_loading_view.dart';
import 'package:the_note_app/app/common/views/info_snackbar_view.dart';
import 'package:the_note_app/app/common/views/input_field.dart';
import 'package:the_note_app/app/routes/app_pages.dart';

import '../controllers/update_password_controller.dart';

class UpdatePasswordView extends GetView<UpdatePasswordController> {
  GlobalKey<FormState> _passwordFormKey = GlobalKey();

  ElevatedButton get _updatePasswordButton => ElevatedButton(
      onPressed: onUpdatePasswordPressed, child: Text("Update Password"));

  Form get _passwordForm => Form(
        key: _passwordFormKey,
        child: Column(
          children: [
            UserInfoField(
              UserInfoFieldType.password,
              textEditingController: this.controller.newPasswordController,
              validator: this.controller.validateFields,
              labelText: "New Password",
            ),
            UserInfoField(
              UserInfoFieldType.password,
              textEditingController:
                  this.controller.newConfirmedPasswordController,
              validator: this.controller.validateFields,
              labelText: "Confirm password",
            ),
          ],
        ),
      );

  void onUpdatePasswordPressed() async {
    if (!(this._passwordFormKey.currentState?.validate() ?? true)) return;
    Result<void, AuthError> updatePasswordResult = await Get.showOverlay(
        loadingWidget: AppLoadingView(),
        asyncFunction:
            this.controller.confirmInputPasswordWithConfirmationCode);

    if (updatePasswordResult is SuccessResult) {
      Get.showSnackbar(InfoSnackBar(
        "Successfully updated the password.",
      ));
      Get.offAllNamed(Routes.LOGIN);
      
    } else if (updatePasswordResult is FailureResult) {
      Get.showSnackbar(InfoSnackBar(
        updatePasswordResult.error?.message ?? "Failed to update password.Try again!",
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Update Password",
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Enter your new password"),
              SizedBox(
                height: 10,
              ),
              _passwordForm,
              SizedBox(
                height: 10,
              ),
              _updatePasswordButton
            ],
          ),
        ));
  }
}
