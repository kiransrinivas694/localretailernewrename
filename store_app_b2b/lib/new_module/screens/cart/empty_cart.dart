import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/new_module/controllers/theme/theme_controller.dart';
import 'package:store_app_b2b/new_module/utils/app_utils.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen.dart';
import 'package:store_app_b2b/widget/app_image_assets.dart';

class EmptyCartScreen extends StatelessWidget {
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: themeController.textPrimaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 80.w,
            height: 35.h,
            child: const AppImageAsset(
              image: "assets/images/cart_empty.png",
              fit: BoxFit.fill,
            ),
          ),
          const Gap(25),
          AppText("Whoops",
              fontFamily: AppFont.poppins,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: themeController.nav6),
          const Gap(18),
          AppText(
            "Your cart is empty!",
            fontFamily: AppFont.poppins,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: themeController.nav6,
          ),
        ],
      ),
    );
  }
}
