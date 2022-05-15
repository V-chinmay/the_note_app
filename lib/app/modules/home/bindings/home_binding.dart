import 'package:get/get.dart';
import 'package:the_note_app/app/data/database/app_database.dart';
import 'package:the_note_app/app/handlers/auth/cognito_auth_handler.dart';
import 'package:the_note_app/app/handlers/providers/note_provider.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  CognitoAuthHandler _cognitoAuthHandler = Get.find();
  @override
  void dependencies() async {
    Get.put(AppDatabaseProxy(_cognitoAuthHandler.currentAuthorizedUserID!));
    Get.put(NoteProvider(
        userID: _cognitoAuthHandler.currentAuthorizedUserID!,
        token: _cognitoAuthHandler.userPoolIdToken!));

    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
