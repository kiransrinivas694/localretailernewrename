import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/new_module/controllers/theme/theme_controller.dart';
import 'package:store_app_b2b/screens/auth/sign_up_2_screen_new.dart';
import 'package:store_app_b2b/widget/app_image_assets_new.dart';

class ConfirmationDialog extends StatelessWidget {
  ConfirmationDialog({
    super.key,
    required this.continueClick,
    this.backClick,
    this.message = "Are you sure you want to delete this",
    this.backText = "No",
    this.continueText = "Yes, Continue",
  });

  final VoidCallback continueClick;
  final VoidCallback? backClick;
  final String message;
  final String backText;
  final String continueText;

  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    // final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Gap(20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(228, 82, 102, 1)),
              child: const AppImageAsset(
                image: "assets/images/delete_popup_icon.png",
                width: 30,
              ),
            ),
            const Gap(19),
            SizedBox(
              width: width / 2,
              child: AppText(
                message,
                fontSize: width * 0.04,
                color: const Color.fromRGBO(100, 100, 100, 1),
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
            ),
            const Gap(30),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      side: const BorderSide(
                        color: Color.fromRGBO(100, 100, 100, 1),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () {
                      if (backClick != null) {
                        backClick!();
                      } else {
                        Get.back();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: AppText(
                        backText,
                        fontSize: width * 0.035,
                        color: const Color.fromRGBO(100, 100, 100, 1),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color.fromRGBO(228, 82, 102, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: continueClick,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: AppText(
                        continueText,
                        fontSize: width * 0.035,
                        color: themeController.textPrimaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
