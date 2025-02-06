import 'package:b2c/utils/string_extensions_new.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/new_module/constant/app_asset_new.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';
import 'package:store_app_b2b/widget/app_image_assets_new.dart';

class AppHeader extends StatelessWidget {
  const AppHeader(
      {super.key,
      required this.title,
      this.titleSize = 20,
      this.backgroundColor,
      this.isTitleNeeded = true,
      this.textColor = Colors.black,
      this.onValueChanged});

  final String? title;
  final double titleSize;
  final Color? backgroundColor;
  final bool isTitleNeeded;
  final Color? textColor;
  final Function()? onValueChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2.0, left: 16),
            child: GestureDetector(
                onTap: () {
                  logs("set called appheaeder");
                  if (onValueChanged != null) {
                    onValueChanged!();
                  } else {
                    Get.back();
                  }
                },
                child: AppImageAsset(
                  image: AppAsset.appBackIcon,
                  color: textColor,
                )),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: isTitleNeeded
                ? AppText(
                    title ?? "",
                    color: textColor,
                    fontSize: titleSize,
                    fontWeight: FontWeight.w600,
                  )
                : const SizedBox(),
          ),
          // Container(
          //     decoration: BoxDecoration(
          //       // color: ,
          //       border: Border.all(color: Colors.black, width: 1),
          //       borderRadius: BorderRadius.circular(100),
          //     ),
          //     padding: const EdgeInsets.all(8),
          //     child: const AppImageAsset(
          //         image: AppAsset.notificationBellActiveIcon)),
          // const SizedBox(
          //   width: 12,
          // ),
        ],
      ),
    );
  }
}
