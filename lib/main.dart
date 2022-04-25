import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData.light().copyWith(
          accentColor: Colors.orange,
          appBarTheme: AppBarTheme(
            centerTitle: false,
            titleTextStyle: TextStyle(fontSize: 32),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
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
