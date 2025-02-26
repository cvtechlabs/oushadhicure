import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'constants.dart';

class SnackBarHelper {
  static void showErrorSnackBar(String message, {String title = "Error"}) {
    final screenWidth = MediaQuery.of(Get.context!).size.width;
    final margin = screenWidth >= 300 ? EdgeInsets.symmetric(horizontal: 300) : EdgeInsets.zero;

    Get.snackbar(
      title,
      message,
      backgroundColor: cbColor,
      colorText: cbFnColor,
      borderRadius: 20,
      margin: margin,
      duration: Duration(seconds: 3),
      icon: Icon(Icons.error, color: cbFnColor),
    );
  }

  static void showSuccessSnackBar(String message, {String title = "Success"}) {
    final screenWidth = MediaQuery.of(Get.context!).size.width;
    final margin = screenWidth >= 300 ? EdgeInsets.symmetric(horizontal: 300) : EdgeInsets.zero;

    Get.snackbar(
      title,
      message,
      backgroundColor: sbColor,
      colorText: sbFnColor,
      borderRadius: 20,
      margin: margin,
      duration: Duration(seconds: 3),
      icon: Icon(Icons.check_circle, color: sbFnColor),
    );
  }
}
