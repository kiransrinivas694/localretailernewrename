import 'dart:io';

import 'package:b2c/constants/colors_const.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/constants/colors_const.dart';

extension SnackBar on String {
  showInfo() {
    Get.snackbar(
      'Info!!',
      this,
      backgroundColor: AppColors.textColor,
      colorText: Colors.white,
    );
  }

  showError() {
    Fluttertoast.showToast(
      msg: this,
      gravity: (Platform.isIOS) ? ToastGravity.TOP : ToastGravity.BOTTOM,
      textColor: ColorsConst.primaryColor,
      backgroundColor: ColorsConst.appWhite,
    );
    // Get.snackbar(
    //   'Error!!',
    //   this,
    //   backgroundColor: AppColors.redColor,
    //   colorText: Colors.white,
    // );
  }

  showSuccess() {
    Fluttertoast.showToast(
      msg: this,
      gravity: ToastGravity.BOTTOM,
      textColor: ColorsConst.greenColor,
      backgroundColor: ColorsConst.appWhite,
    );
    // Get.snackbar(
    //   'Success!!',
    //   this,
    //   backgroundColor: AppColors.greenColor,
    //   colorText: Colors.white,
    // );
  }

  copyText() {
    Clipboard.setData(ClipboardData(text: this));
    'Copied successfully'.showSuccess();
  }

  // shareText() => Share.share(this);
}

void logs(String message) {
  // if (kDebugMode) {
  print(message);
  // }
}
