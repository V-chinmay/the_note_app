import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/route_middleware.dart';
import 'package:get/state_manager.dart';
import 'package:the_note_app/app/modules/home/controllers/home_controller.dart';
import 'package:the_note_app/app/modules/note_edit/controllers/note_edit_controller.dart';
import 'package:the_note_app/app/modules/note_edit/note_model.dart';
import 'package:the_note_app/app/modules/note_edit/views/note_edit_view.dart';
import 'package:the_note_app/app/routes/app_pages.dart';
import 'package:get/get.dart';

class NavigationMiddleWare extends GetMiddleware {
  
  @override
  GetPageBuilder? onPageBuildStart(GetPageBuilder? page) {
    if (page == null) return null;
    switch (page().runtimeType) {
      case NoteEditView:
        NoteEditController noteEditController = Get.find();
        Note? note = (Get.arguments as Note);
        if (note == null) return null;

        noteEditController.note = note;
        return page;
      default:
        return page;
    }
    return super.onPageBuildStart(page);
  }

  @override
  Widget onPageBuilt(Widget page) {
    // TODO: implement onPageBuilt
    return super.onPageBuilt(page);
  }
}
