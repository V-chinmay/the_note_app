import 'package:get/get.dart';

import 'package:the_note_app/app/modules/home/bindings/home_binding.dart';
import 'package:the_note_app/app/modules/home/views/home_view.dart';
import 'package:the_note_app/app/modules/login/bindings/login_binding.dart';
import 'package:the_note_app/app/modules/login/views/login_view.dart';
import 'package:the_note_app/app/modules/note_edit/bindings/note_edit_binding.dart';
import 'package:the_note_app/app/modules/note_edit/views/note_edit_view.dart';
import 'package:the_note_app/app/routes/navigation_middleware.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      middlewares: [Get.find<NavigationMiddleWare>()]
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
      middlewares: [Get.find<NavigationMiddleWare>()]
    ),
    GetPage(
      name: _Paths.NOTE_EDIT,
      transition: Transition.cupertino,
      page: () => NoteEditView(),
      binding: NoteEditBinding(),
      middlewares: [Get.find<NavigationMiddleWare>()]
    ),
  ];
}
