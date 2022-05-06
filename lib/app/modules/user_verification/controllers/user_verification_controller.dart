import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:the_note_app/app/common/errors.dart';
import 'package:the_note_app/app/common/result.dart';
import 'package:the_note_app/app/handlers/auth/auth_handler.dart';
import 'package:the_note_app/app/handlers/auth/cognito_auth_handler.dart';

class UserVerificationController extends GetxController {
  TextEditingController verificationCodeController = TextEditingController();
  
  String? userEmailID;

  late CognitoAuthHandler _cognitoAuthHandler = Get.find();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }


  Future<Result<AuthStatus,AuthError>> verifyUserWithInputCode()
  {
    return _cognitoAuthHandler.verifyUser(this.userEmailID!,verificationCodeController.text);    
  }


  Future<Result<Null,AuthError>> resendConfirmationCode()
  {
    return _cognitoAuthHandler.resendVerificationCode(this.userEmailID!);    
  }

  @override
  void onClose() {

  }
}
