import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:the_note_app/app/data/database/app_database.dart';
import 'package:the_note_app/app/handlers/auth/cognito_auth_handler.dart';

import 'app/routes/app_pages.dart';
import 'app/routes/navigation_middleware.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(NavigationMiddleWare());
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData.dark().copyWith(
          accentColor: Colors.orange,
          appBarTheme: AppBarTheme(
            centerTitle: false,
            titleTextStyle: TextStyle(fontSize: 32),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.orange))
          ),
          scaffoldBackgroundColor: Color.fromRGBO(0x10, 0x11, 0x11, 1),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              foregroundColor: Colors.white,
              backgroundColor: Color.fromRGBO(0x10, 0x11, 0x11, 1)),
          textTheme: TextTheme(
              headline6: TextStyle(color: Colors.blueGrey, fontSize: 24),
              subtitle1: TextStyle(color: Colors.blueGrey, fontSize: 16)),
          inputDecorationTheme: InputDecorationTheme(
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange)),
              labelStyle: TextStyle(color: Colors.white))),
    ),
  );
}
