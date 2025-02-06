import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/constants/colors_const.dart';

extension SnackBar on String {
  showInfo() {
    Get.snackbar(
      'Info!!',
      this,
      backgroundColor: ColorsConst.greyBgColor,
      colorText: ColorsConst.appWhite,
    );
  }

  showError() {
    Fluttertoast.showToast(
      msg: this,
      gravity: ToastGravity.BOTTOM,
      textColor: ColorsConst.primaryColor,
      backgroundColor: ColorsConst.appWhite,
    );
    // Get.snackbar(
    //   'Error!!',
    //   this,
    //   backgroundColor: ColorsConst.redColor,
    //   colorText: ColorsConst.appWhite,
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
    //   backgroundColor: ColorsConst.greenColor,
    //   colorText: ColorsConst.appWhite,
    // );
  }

  copyText() {
    Clipboard.setData(ClipboardData(text: this));
    'Copied successfully'.showSuccess();
  }

  // shareText() => Share.share(this);
}
