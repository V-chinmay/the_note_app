import 'package:get/get_navigation/src/snackbar/snackbar.dart';

class InfoSnackBar extends GetSnackBar {
  InfoSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 1),
  }) : super(duration: duration, snackPosition: SnackPosition.BOTTOM);
}
