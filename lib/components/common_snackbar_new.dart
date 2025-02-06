import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:store_app_b2b/components/custom_toast_new.dart';
import 'package:store_app_b2b/constants/colors_const_new.dart';

class CommonSnackBar {
  static void showError(error) {
    Fluttertoast.showToast(
      msg: error,
      gravity: ToastGravity.BOTTOM,
      textColor: ColorsConst.appWhite,
      backgroundColor: ColorsConst.primaryColor,
    );
    // Get.snackbar(
    //   snackPosition: SnackPosition.BOTTOM,
    //   'Error!!',
    //   error,
    //   backgroundColor: AppColors.primaryColor,
    //   colorText: AppColors.appWhite,
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
}
