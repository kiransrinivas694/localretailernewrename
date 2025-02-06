import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/custom_toast_new.dart';

import 'package:store_app_b2b/constants/colors_const_new.dart';
import 'package:store_app_b2b/utils/string_extensions_new.dart';

class CommonSnackBar {
  static void showError(error) {
    Fluttertoast.showToast(
      msg: error,
      gravity: ToastGravity.BOTTOM,
      textColor: ColorsConst.appWhite,
      backgroundColor: ColorsConst.primaryColor,
      toastLength: Toast.LENGTH_LONG,
    );
    // Get.snackbar(
    //   margin: EdgeInsets.only(top: 20,left: 20,right: 20),
    //   snackPosition: SnackPosition.BOTTOM,
    //   'Error!!',

    //   error,
    //   backgroundColor: ColorsConst.primaryColor,
    //   colorText: ColorsConst.appWhite,
    // );
  }

  static void showToast(String toastMessage, BuildContext context,
      {bool showTickMark = true, double? width}) {
    FToast().init(context);
    FToast().showToast(
        gravity: ToastGravity.BOTTOM,
        child: CustomToastWidget(
          msg: toastMessage,
          showTickMark: showTickMark,
          width: width,
        ));
  }

  static void showInfo(title) {
    Fluttertoast.showToast(
      msg: title,
      gravity: ToastGravity.BOTTOM,
      textColor: Colors.white,
      backgroundColor: ColorsConst.textColor,
    );
    // Get.snackbar(
    //   'Info!!',
    //   title,
    //   backgroundColor: ColorsConst.textColor,
    //   colorText: Colors.white,
    // );
  }

  static void showSuccess(title) {
    Fluttertoast.showToast(
      msg: title,
      gravity: ToastGravity.BOTTOM,
      textColor: ColorsConst.greenColor,
      backgroundColor: ColorsConst.appWhite,
    );
    // Get.snackbar(
    //   'Success!!',
    //   title,
    //   backgroundColor: ColorsConst.greenColor,
    //   colorText: Colors.white,
    // );
  }

  static void copyText(text) {
    Clipboard.setData(ClipboardData(text: text));
    'Copied successfully'.showSuccess();
  }
}
