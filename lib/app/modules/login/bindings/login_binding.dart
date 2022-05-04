import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_flutter/categories/amplify_categories.dart';
import 'package:get/get.dart';
import 'package:the_note_app/app/common/amplifyconfiguration.dart';
import 'package:the_note_app/app/handlers/auth/cognito_auth_handler.dart';

import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() async {
    
    Get.lazyPut<LoginController>(
      () => LoginController(),
    );    
    
    await Amplify.addPlugin(AmplifyAuthCognito());
    await Amplify.configure(cognitoConfig);
    Get.put(CognitoAuthHandler(Amplify.Auth));

  }
}
