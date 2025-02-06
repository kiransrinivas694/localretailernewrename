import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/new_module/constant/app_asset.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen.dart';
import 'package:store_app_b2b/widget/app_image_assets.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Color? backgroundColor;
  final bool isTitleNeeded;
  final bool isIconNeeded;
  final Function()? onBack;

  const AppAppBar(
      {Key? key,
      required this.title,
      this.backgroundColor,
      this.isTitleNeeded = true,
      this.isIconNeeded = false,
      this.onBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 0,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: GestureDetector(
                onTap: onBack == null
                    ? () {
                        Get.back();
                      }
                    : onBack,
                child: Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 10, 20),
                    child: const AppImageAsset(
                      image: AppAsset.appBackIcon,
                    ))),
          ),
          const SizedBox(
            width: 0,
          ),
          Expanded(
              child: isTitleNeeded
                  ? AppText(
                      title ?? "",
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    )
                  : const SizedBox()),
          //functionality commented - notification icon bell
          // isIconNeeded
          //     ? Container(
          //         decoration: BoxDecoration(
          //           // color: ,
          //           border: Border.all(color: Colors.black, width: 1),
          //           borderRadius: BorderRadius.circular(100),
          //         ),
          //         padding: const EdgeInsets.all(8),
          //         child:
          //             AppImageAsset(image: AppAsset.notificationBellActiveIcon))
          //     : SizedBox(),
          const SizedBox(
            width: 12,
          ),
        ],
      ),
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor ?? Colors.white,
      titleSpacing: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
