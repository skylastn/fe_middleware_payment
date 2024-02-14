import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';

class Snackbar {
  static void showInfo(
      {String? title,
      required String message,
      Duration? duration,
      Color? textColor,
      Color? backgroundColor}) {
    double width = 300;
    Get.log(message.length.toString());
    if (message.length < 30) {
      width = 12 * message.length.toDouble();
    }
    Get.rawSnackbar(
      title: title,
      messageText: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(color: textColor ?? Colors.white),
      ),
      // colorText: Colors.white,
      backgroundColor: backgroundColor ?? hexToColor('#757575'),
      duration: duration ?? const Duration(seconds: 3),
      snackPosition: SnackPosition.BOTTOM,
      maxWidth: width,
      margin: const EdgeInsets.only(
        bottom: 40,
        // left: 20,
        // right: 20,
      ),
      borderRadius: 15,
    );
  }

  static void showToastDuration({
    String? title,
    required String message,
    Rx<int>? duration,
    Color textColor = Colors.black,
    Color backgroundColor = Colors.white,
  }) {
    double width = 300;
    if (message.length < 30) {
      width = 9 * message.length.toDouble();
    }
    duration ??= 3.obs;
    Get.rawSnackbar(
      title: title,
      messageText: Obx(
        () => Text(
          '$message (${duration?.value})',
          textAlign: TextAlign.center,
          style: TextStyle(color: textColor),
        ),
      ),
      backgroundColor: backgroundColor,
      duration: Duration(seconds: duration.value),
      snackPosition: SnackPosition.BOTTOM,
      maxWidth: width,
      margin: const EdgeInsets.only(
        bottom: 40,
      ),
      borderRadius: 15,
    );
  }
}
