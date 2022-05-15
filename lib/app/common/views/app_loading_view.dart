import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppLoadingView extends StatelessWidget {
  const AppLoadingView({Key? key, this.message = "Please wait..."})
      : super(key: key);
  final String message;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(
            height: 10,
          ),
          Text(
            this.message,
            style: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.none,
                fontSize: 16),
          )
        ],
      ),
    );
  }

  static void show({String? message}) {
    showDialog(
      context: Get.context!,
      builder: (context) => message != null
          ? AppLoadingView(
              message: message,
            )
          : AppLoadingView(),
    );
  }

  static void dismiss() => Get.back();
}
