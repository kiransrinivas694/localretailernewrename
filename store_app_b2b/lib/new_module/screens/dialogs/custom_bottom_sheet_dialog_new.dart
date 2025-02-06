import 'package:b2c/screens/auth/sign_up_2_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/new_module/controllers/theme/theme_controller_new.dart';
import 'package:store_app_b2b/new_module/utils/app_utils_new.dart';

class CustomBottomSheet extends StatelessWidget {
  CustomBottomSheet({
    Key? key,
    required this.continueClick,
    required this.helpLine,
  }) : super(key: key);

  final VoidCallback continueClick;
  final String helpLine;
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 28.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: themeController.textPrimaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AppText(
            'Lucid Diagnostic Contact',
            fontFamily: AppFont.poppins,
            fontSize: 18.sp,
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.w400,
            color: themeController.black300Color,
          ),
          Gap(2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      makePhoneCall("$helpLine");
                    },
                    child: Icon(
                      Icons.phone,
                      color: themeController.navShadow1,
                      size: 20,
                    ),
                  ),
                  Column(
                    children: [
                      AppText(
                        "Help Line-1",
                        fontFamily: AppFont.poppins,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: themeController.black300Color,
                      ),
                      AppText(
                        "24 Hrs",
                        fontFamily: AppFont.poppins,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: themeController.navShadow1,
                      )
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  makePhoneCall(helpLine);
                },
                child: AppText(
                  helpLine,
                  fontFamily: AppFont.poppins,
                  fontSize: 16.sp,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w400,
                  color: themeController.navShadow1,
                ),
              ),
            ],
          ),
          Gap(2.h),
          Expanded(
            child: Text.rich(TextSpan(
                text: "Note:",
                style: TextStyle(
                  fontFamily: AppFont.poppins,
                  fontSize: 16.sp,
                  color: themeController.black300Color,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  TextSpan(
                    text:
                        "By Booking this test, need to take appointment from Diagnostic Centre.",
                    style: TextStyle(
                      fontFamily: AppFont.poppins,
                      fontSize: 15.sp,
                      color: themeController.textSecondaryColor,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.none,
                    ),
                  )
                ])),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.topEnd,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: themeController.navShadow1,
                ),
                onPressed: continueClick,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: AppText(
                    "Continue",
                    fontSize: 15.sp,
                    color: themeController.textPrimaryColor,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFont.poppins,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void show(
    BuildContext context, {
    required VoidCallback continueClick,
    required String helpLine,
    VoidCallback? cancelClick,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (BuildContext context) {
        return CustomBottomSheet(
          continueClick: continueClick,
          helpLine: helpLine,
        );
      },
    );
  }
}
