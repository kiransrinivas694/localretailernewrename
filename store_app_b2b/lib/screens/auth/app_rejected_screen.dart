import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:store_app_b2b/components/common_primary_button.dart';
import 'package:store_app_b2b/components/common_text.dart';
import 'package:store_app_b2b/constants/colors_const.dart';
import 'package:store_app_b2b/controllers/auth_controller/app_process_controller.dart';
import 'package:store_app_b2b/screens/auth/login_screen.dart';
import 'package:store_app_b2b/screens/auth/partial_update_screen.dart';
import 'package:store_app_b2b/screens/auth/supplier_onboard_screen.dart';
import 'package:store_app_b2b/screens/bottom_nav_bar/profile_screens/edit_profile_screen.dart';
import 'package:store_app_b2b/utils/shar_preferences.dart';

import '../bottom_nav_bar/profile_screens/profile_screen.dart';

class AppRejectedScreen extends StatelessWidget {
  AppRejectedScreen(
      {Key? key,
      this.email,
      this.password,
      required this.reasonReject,
      this.profileDetails,
      required this.userId})
      : super(key: key);
  String? email = "";
  String? password = "";
  String userId;
  Map<String, dynamic>? profileDetails;
  List<String> reasonReject = [];
  final AppProcessController appProcessController =
      Get.put(AppProcessController());
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    log('log profile details inside rejected screen ${profileDetails}');
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/image/bg.png"),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  // color: Colors.red,
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/image/application_rejected.png",
                          // scale: 4.5,
                          width: 40.w,
                          package: 'store_app_b2b',
                        ),
                        SizedBox(height: 20),
                        CommonText(
                          content: "Your application is Rejected",
                          textSize: 17.sp,
                        ),
                        SizedBox(
                          height: height / 12,
                        ),
                        CommonText(
                          content: "Reason :",
                          textSize: 18,
                          decoration: TextDecoration.underline,
                        ),
                        SizedBox(height: height * 0.01),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              List.generate((reasonReject).length, (index) {
                            return CommonText(
                              content: reasonReject[index] == "NSA"
                                  ? "Service not available by selected supplier.\nplease select another supplier"
                                  : reasonReject[index],
                              textAlign: TextAlign.center,
                              textSize: 16,
                            );
                          }),
                        ),
                        SizedBox(height: height / 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: reasonReject.contains("NSA")
                              ? Container(
                                  width: 190,
                                  child: CommonPrimaryButton(
                                      text: "Select Supplier",
                                      onTap: () async {
                                        // Get.to(() => ProfileScreen(
                                        //       screenType: "reject",
                                        //       userId: userId,
                                        //     ));

                                        String categoryId =
                                            await SharPreferences.getString(
                                                    SharPreferences
                                                        .storeCategoryId) ??
                                                "";
                                        Get.offAll(SupplierOnboardScreen(
                                          retailerId: userId,
                                        ));
                                        // Get.to(
                                        //   () => PartialUpdateScreen(
                                        //     types: ['gst', 'store', 'drug'],
                                        //     profileData: profileDetails ?? {},
                                        //   ),
                                        // );
                                      }),
                                )
                              : GestureDetector(
                                  onTap: () async {
                                    // String categoryId =
                                    //     await SharPreferences.getString(
                                    //             SharPreferences
                                    //                 .storeCategoryId) ??
                                    //         "";
                                    // Get.to(SupplierOnboardScreen(
                                    //   retailerId: userId,
                                    // ));
                                  },
                                  child: CommonText(
                                      content:
                                          "Please contact admin to update the details"),
                                ),
                          // CommonPrimaryButton(
                          //     text: "Edit Profile",
                          //     onTap: () {
                          //       Get.to(() => ProfileScreen(
                          //             screenType: "reject",
                          //           ));
                          //       // Get.to(
                          //       //   () => PartialUpdateScreen(types: []),
                          //       // );
                          //     }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Center(
              //   child: SizedBox(
              //     // width: width / 1.3,
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         // Center(
              //         //   child: CommonText(
              //         //     content:
              //         //         "Use the below details to login and check your status",
              //         //     textSize: width * 0.035,
              //         //   ),
              //         // ),
              //         // SizedBox(height: height * 0.01),
              //         // Row(
              //         //   children: [
              //         //     CommonText(
              //         //       content: "Email : ",
              //         //       textSize: width * 0.035,
              //         //     ),
              //         //     CommonText(
              //         //         content: email,
              //         //         textSize: width * 0.035,
              //         //         textColor: ColorsConst.primaryColor),
              //         //   ],
              //         // ),
              //         // Row(
              //         //   children: [
              //         //     CommonText(
              //         //       content: "Password : ",
              //         //       textSize: width * 0.035,
              //         //     ),
              //         //     CommonText(
              //         //         content: password,
              //         //         textSize: width * 0.035,
              //         //         textColor: ColorsConst.primaryColor),
              //         //   ],
              //         // ),
              //       ],
              //     ),
              //   ),
              // ),
              // SizedBox(height: height * 0.08),
              // Image.asset(
              //   "assets/image/application_rejected.png",
              //   // scale: 4.5,
              //   width: 40.w,
              //   package: 'store_app_b2b',
              // ),
              // SizedBox(height: 20),
              // CommonText(
              //   content: "Your application is Rejected",
              //   textSize: 17.sp,
              // ),
              // Center(
              //   child: SizedBox(
              //     width: width / 2,
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         // CommonText(
              //         //   content: "Your application is Rejected",
              //         //   textSize: width * 0.035,
              //         // ),
              //         SizedBox(height: height * 0.02),
              //         CommonText(
              //           content: "Reason :",
              //           textSize: width * 0.035,
              //         ),
              //         SizedBox(height: height * 0.01),
              //         Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: List.generate((reasonReject).length, (index) {
              //             return CommonText(
              //               content: reasonReject[index] == "NSA"
              //                   ? "Service not available by selected supplier..please select another supplier"
              //                   : reasonReject[index],
              //               textSize: width * 0.035,
              //             );
              //           }),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // const Spacer(),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: reasonReject.contains("NSA")
              //       ? CommonPrimaryButton(
              //           text: "Select Supplier",
              //           onTap: () {
              //             // Get.to(() => ProfileScreen(
              //             //       screenType: "reject",
              //             //       userId: userId,
              //             //     ));
              //             Get.offAll(SupplierOnboardScreen(retailerId: userId));
              //             // Get.to(
              //             //   () => PartialUpdateScreen(
              //             //     types: ['gst', 'store', 'drug'],
              //             //     profileData: profileDetails ?? {},
              //             //   ),
              //             // );
              //           })
              //       : CommonPrimaryButton(
              //           text: "Edit Profile",
              //           onTap: () {
              //             Get.to(() => ProfileScreen(
              //                   screenType: "reject",
              //                 ));
              //             // Get.to(
              //             //   () => PartialUpdateScreen(types: []),
              //             // );
              //           }),
              // ),
              // SizedBox(height: height * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
