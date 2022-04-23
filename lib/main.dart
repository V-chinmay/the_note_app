import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
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
          ),
          inputDecorationTheme: InputDecorationTheme(
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange)),
              labelStyle: TextStyle(color: Colors.white))),
    ),
  );
}
