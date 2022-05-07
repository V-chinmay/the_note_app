import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/route_middleware.dart';
import 'package:get/state_manager.dart';
import 'package:the_note_app/app/handlers/auth/auth_handler.dart';
import 'package:the_note_app/app/handlers/auth/cognito_auth_handler.dart';
import 'package:the_note_app/app/modules/home/controllers/home_controller.dart';
import 'package:the_note_app/app/modules/note_edit/controllers/note_edit_controller.dart';
import 'package:the_note_app/app/data/models/note_model.dart';
import 'package:the_note_app/app/modules/note_edit/views/note_edit_view.dart';
import 'package:the_note_app/app/modules/update_password/controllers/update_password_controller.dart';
import 'package:the_note_app/app/modules/update_password/views/update_password_view.dart';
import 'package:the_note_app/app/modules/user_verification/controllers/user_verification_controller.dart';
import 'package:the_note_app/app/modules/user_verification/views/user_verification_view.dart';
import 'package:the_note_app/app/routes/app_pages.dart';
import 'package:get/get.dart';

class NavigationMiddleWare extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    switch (route) {
      case Routes.LOGIN:
        if (Get.find<CognitoAuthHandler>().authStatus ==
            AuthStatus.Authorized) {
          return RouteSettings(name: Routes.HOME);
        }
        break;
      default:
        if (Get.find<CognitoAuthHandler>().authStatus !=
            AuthStatus.Authorized) {
          return RouteSettings(name:Routes.LOGIN);
        }
    }
    return super.redirect(route);
  }

  @override
  GetPageBuilder? onPageBuildStart(GetPageBuilder? page) {
    if (page == null) return null;
    switch (page().runtimeType) {
      case NoteEditView:
        NoteEditController noteEditController = Get.find();
        Note? note = (Get.arguments["note"] as Note);
        if (note == null) return null;

        bool isNoteNew = Get.arguments["isNewNote"] ?? true;

        noteEditController.isNewNote = isNoteNew;
        noteEditController.note = note;
        return page;
      case UserVerificationView:
        String? username = Get.arguments["username"];
        UserVerificationType? userVerificationType =
            Get.arguments["userVerificationType"];
        if (username == null || userVerificationType == null) return null;
        UserVerificationController userVerificationController = Get.find();
        userVerificationController.userEmailID = username;
        userVerificationController.userVerificationType = userVerificationType;
        return page;
      case UpdatePasswordView:
        String? username = Get.arguments["username"];
        String? confirmationCode = Get.arguments["confirmationCode"];
        if (username == null || confirmationCode == null) return null;
        UpdatePasswordController updatePasswordController = Get.find();
        updatePasswordController.username = username;
        updatePasswordController.confirmationCode = confirmationCode;
        return page;
      default:
        return page;
    }
  }

  @override
  Widget onPageBuilt(Widget page) {
    // TODO: implement onPageBuilt
    return super.onPageBuilt(page);
  }
}
