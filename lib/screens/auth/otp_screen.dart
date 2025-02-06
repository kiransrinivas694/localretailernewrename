import 'dart:developer';

import 'package:b2c/components/common_primary_button.dart';
import 'package:b2c/components/common_text.dart';
import 'package:b2c/constants/colors_const.dart';
import 'package:b2c/controllers/auth_controller/otp_controller.dart';
import 'package:b2c/controllers/auth_controller/signup_controller.dart';
import 'package:b2c/screens/auth/app_pending_screen.dart';
import 'package:b2c/screens/auth/app_rejected_screen.dart';
import 'package:b2c/screens/bottom_tap_bar_screen.dart';
import 'package:b2c/service/location_service.dart';
import 'package:b2c/utils/shar_preferences.dart';
import 'package:b2c/widget/app_image_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_process_screen.dart';

class OTPScreen extends StatelessWidget {
  OTPScreen({Key? key, this.type, this.mobile}) : super(key: key);
  String? type = "";
  String? mobile = "";
  final registerOtp = Get.put(SignupController());
  final otpController = Get.put(OTPController());

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          body: GetBuilder<OTPController>(
            init: OTPController(),
            initState: (state) async {
              otpController.phoneController.text = mobile!;
              otpController.manageTimer();
              await otpController.getOtp("send");
            },
            builder: (controller) {
              return Stack(
                children: [
                  AppImageAsset(
                      image: 'assets/image/bg.png',
                      height: height,
                      width: width,
                      fit: BoxFit.cover),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      Center(
                        child: CommonText(
                          content: "ONE FINAL STEP...",
                          textSize: width * 0.055,
                          boldNess: FontWeight.w600,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Center(
                                child: CommonText(
                                    content:
                                        "OTP has been sent to\n${controller.phoneController.text}"),
                              ),
                              SizedBox(height: height * 0.02),
                              SizedBox(
                                height: 55,
                                child: OtpTextField(
                                  styles: [
                                    TextStyle(
                                        fontSize: 20,
                                        color: AppColors.appWhite,
                                        fontWeight: FontWeight.w600),
                                    TextStyle(
                                        fontSize: 20,
                                        color: AppColors.appWhite,
                                        fontWeight: FontWeight.w600),
                                    TextStyle(
                                        fontSize: 20,
                                        color: AppColors.appWhite,
                                        fontWeight: FontWeight.w600),
                                    TextStyle(
                                        fontSize: 20,
                                        color: AppColors.appWhite,
                                        fontWeight: FontWeight.w600),
                                    TextStyle(
                                        fontSize: 20,
                                        color: AppColors.appWhite,
                                        fontWeight: FontWeight.w600),
                                    TextStyle(
                                        fontSize: 20,
                                        color: AppColors.appWhite,
                                        fontWeight: FontWeight.w600),
                                  ],
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(bottom: 0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.semiGreyColor),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.semiGreyColor),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.semiGreyColor),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.semiGreyColor),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  textStyle:
                                      GoogleFonts.poppins(color: Colors.white),
                                  numberOfFields: 6,
                                  enabledBorderColor: AppColors.semiGreyColor,
                                  disabledBorderColor: AppColors.semiGreyColor,
                                  focusedBorderColor: AppColors.semiGreyColor,
                                  cursorColor: AppColors.semiGreyColor,
                                  borderColor: AppColors.semiGreyColor,
                                  showFieldAsBox: true,
                                  autoFocus: false,
                                  borderWidth: 1,
                                  fieldWidth: 50,
                                  onCodeChanged: (String code) {},
                                  onSubmit: (String verificationCode) {
                                    registerOtp.otp = verificationCode;
                                    controller.otp = verificationCode;
                                    print(controller.otp);
                                  }, // end onSubmit
                                ),
                              ),
                              SizedBox(height: height * 0.03),
                              if (controller.timer != null &&
                                  controller.timer!.isActive)
                                Center(
                                  child: CommonText(
                                    content:
                                        "00:${controller.timerValue.value.toString().padLeft(2, '0')}",
                                    boldNess: FontWeight.w400,
                                  ),
                                ),
                              SizedBox(height: height * 0.03),
                              if (controller.timer == null ||
                                  !controller.timer!.isActive)
                                InkWell(
                                  onTap: () {
                                    otpController.getOtp("resend");
                                    controller.manageTimer();
                                  },
                                  child: Column(
                                    children: [
                                      Center(
                                        child: CommonText(
                                          content: "Didn’t receive it?",
                                          boldNess: FontWeight.w400,
                                          textColor: AppColors.primaryColor,
                                        ),
                                      ),
                                      SizedBox(height: height * 0.04),
                                      const Center(
                                        child: CommonText(
                                          content: "Resend OTP",
                                          boldNess: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(height: height * 0.03),
                                    ],
                                  ),
                                ),
                              controller.isVerified == true
                                  ? Center(
                                      child: Container(
                                        height: 35,
                                        width: width / 3.8,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Center(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const CircleAvatar(
                                                radius: 10,
                                                backgroundColor: Colors.white,
                                                child: Center(
                                                  child: Icon(
                                                    Icons.done,
                                                    color: Colors.green,
                                                    size: 10,
                                                  ),
                                                ),
                                              ),
                                              CommonText(
                                                content: "  Verified",
                                                textColor: Colors.white,
                                                textSize: width * 0.03,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : controller.isVerified == null
                                      ? const SizedBox()
                                      : Center(
                                          child: Container(
                                            height: 35,
                                            width: width / 3.8,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Center(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons.error,
                                                    color: Colors.red,
                                                  ),
                                                  CommonText(
                                                    content: " Invalid OTP",
                                                    textColor: Colors.red,
                                                    textSize: width * 0.03,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !keyboardIsOpen,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: CommonPrimaryButton(
                                  isLoading: controller.isLoading.value,
                                  text: 'Verify Now',
                                  onTap: () async {
                                    await controller
                                        .verifyOtp()
                                        .then((value) async {
                                      log('Value --> $value');
                                      await controller.mobileVerify().then(
                                        (login) async {
                                          controller.isVerified = true;
                                          await LocationService.instance
                                              .checkLocationPermission();
                                          print("bodyMap <<<<<<<==>>$login");
                                          await LocationService.instance
                                              .checkLocationPermission();
                                          if (login != null) {
                                            await controller
                                                .profileStatus(login['logInId'])
                                                .then((value) async {
                                              if (value != null) {
                                                print(
                                                    "bodyMap  value<<<<<<<==>> $value");
                                                await SharPreferences.setString(
                                                    SharPreferences.loginId,
                                                    login['logInId'] ?? "");
                                                print(
                                                    ">>>>>>>>>applicationStatus>>>>>>>${value['applicationStatus']}");
                                                await SharPreferences.setString(
                                                    SharPreferences.accessToken,
                                                    "Bearer ${login['fcmToken']}" ??
                                                        "");
                                                print(
                                                    value['applicationStatus']);
                                                if (value[
                                                        'applicationStatus'] ==
                                                    "Onboarded") {
                                                  await SharPreferences.setString(
                                                      SharPreferences
                                                          .storeCategoryId,
                                                      value['storeCategoryId'] ??
                                                          "");
                                                  await SharPreferences
                                                      .setString(
                                                          SharPreferences
                                                              .storeName,
                                                          value['storeName'] ??
                                                              "");
                                                  await SharPreferences
                                                      .setString(
                                                          SharPreferences
                                                              .storeNumber,
                                                          value['storeNumber'] ??
                                                              "");
                                                  await SharPreferences
                                                      .setBoolean(
                                                          SharPreferences
                                                              .isLogin,
                                                          true);
                                                  Get.offAll(
                                                      () => const HomeScreen(),
                                                      transition:
                                                          Transition.size);
                                                } else if (value[
                                                        'applicationStatus'] ==
                                                    "Pending") {
                                                  print(
                                                      ">>>>>>>>>>>>>>>>>>>>>>>>>>>>${value['applicationStatus'] == "Pending"}");
                                                  Get.to(
                                                      () => AppPendingScreen(),
                                                      transition:
                                                          Transition.size);
                                                } else if (value[
                                                        'applicationStatus'] ==
                                                    "Rejected") {
                                                  Get.to(
                                                    transition: Transition.size,
                                                    () => AppRejectedScreen(
                                                      email: value['email'],
                                                      password:
                                                          value['password'],
                                                      reasonReject:
                                                          value["reason"] ?? {},
                                                    ),
                                                  );
                                                }
                                              }
                                            });
                                          }
                                        },
                                      );
                                      // if (value["type"] == "success") {
                                      //   if (type == "mobile") {
                                      //     await controller.mobileVerify().then((login) async {
                                      //       await LocationService.instance.checkLocationPermission();
                                      //       print("bodyMap <<<<<<<==>>$login");
                                      //       await LocationService.instance.checkLocationPermission();
                                      //       if (login != null) {
                                      //         await controller.profileStatus(login['logInId']).then((value) async {
                                      //           if (value != null) {
                                      //             print("bodyMap  value<<<<<<<==>> $value");
                                      //             await SharPreferences.setString(
                                      //                 SharPreferences.loginId, login['logInId'] ?? "");
                                      //
                                      //             print(">>>>>>>>>applicationStatus>>>>>>>${value['applicationStatus']}");
                                      //             await SharPreferences.setString(
                                      //                 SharPreferences.accessToken, "Bearer ${login['fcmToken']}" ?? "");
                                      //             print(value['applicationStatus']);
                                      //             if (value['applicationStatus'] == "Onboarded") {
                                      //               await SharPreferences.setString(
                                      //                   SharPreferences.storeCategoryId, value['storeCategoryId'] ?? "");
                                      //               await SharPreferences.setString(
                                      //                   SharPreferences.storeName, value['storeName'] ?? "");
                                      //               await SharPreferences.setBoolean(SharPreferences.isLogin, true);
                                      //               Get.offAll(() => const HomeScreen(), transition: Transition.size);
                                      //             } else if (value['applicationStatus'] == "Pending") {
                                      //               print(
                                      //                   ">>>>>>>>>>>>>>>>>>>>>>>>>>>>${value['applicationStatus'] == "Pending"}");
                                      //               Get.to(() => AppPendingScreen(), transition: Transition.size);
                                      //             } else if (value['applicationStatus'] == "Rejected") {
                                      //               Get.to(
                                      //                   () => AppRejectedScreen(
                                      //                       email: value['email'],
                                      //                       password: value['password'],
                                      //                       reasonReject: value["reason"] ?? {}),
                                      //                   transition: Transition.size);
                                      //             }
                                      //           }
                                      //         });
                                      //       }
                                      //     });
                                      //   } else if (type == "register") {
                                      //     await registerOtp.registerPost().then((register) {
                                      //       print(">>>>>>>>>>>>>>>>register>>>>>>>>   $register");
                                      //       if (register['status'] == true) {
                                      //         Get.to(() => AppProcessScreen(), transition: Transition.size);
                                      //       }
                                      //     });
                                      //   } else {
                                      //     Get.to(() => AppProcessScreen(), transition: Transition.size);
                                      //   }
                                      // }
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            Center(
                              child: CommonText(
                                textSize: width * 0.035,
                                content:
                                    "Terms and Conditions applied Privacy policy",
                              ),
                            ),
                            Center(
                              child: CommonText(
                                textSize: width * 0.035,
                                content: "Privacy policy",
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              );
            },
            // builder: (controller) => Container(
            //   width: width,
            //   height: height,
            //   decoration: const BoxDecoration(
            //     image: DecorationImage(
            //       fit: BoxFit.cover,
            //       image: AssetImage("assets/image/bg.png"),
            //     ),
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       IconButton(
            //         onPressed: () {
            //           Get.back();
            //         },
            //         icon: const Icon(
            //           Icons.arrow_back,
            //           color: Colors.white,
            //         ),
            //       ),
            //       Center(
            //         child: CommonText(
            //           content: "ONE FINAL STEP...",
            //           textSize: width * 0.055,
            //           boldNess: FontWeight.w600,
            //         ),
            //       ),
            //       SizedBox(height: height * 0.18),
            //       Center(
            //         child: CommonText(content: "OTP has been sent to\n${controller.phoneController.text}"),
            //       ),
            //       SizedBox(height: height * 0.02),
            //       SizedBox(
            //         height: 55,
            //         child: OtpTextField(
            //           styles: [
            //             TextStyle(fontSize: 20, color: AppColors.appWhite, fontWeight: FontWeight.w600),
            //             TextStyle(fontSize: 20, color: AppColors.appWhite, fontWeight: FontWeight.w600),
            //             TextStyle(fontSize: 20, color: AppColors.appWhite, fontWeight: FontWeight.w600),
            //             TextStyle(fontSize: 20, color: AppColors.appWhite, fontWeight: FontWeight.w600),
            //             TextStyle(fontSize: 20, color: AppColors.appWhite, fontWeight: FontWeight.w600),
            //             TextStyle(fontSize: 20, color: AppColors.appWhite, fontWeight: FontWeight.w600),
            //           ],
            //           decoration: InputDecoration(
            //             contentPadding: const EdgeInsets.only(bottom: 0),
            //             focusedBorder: OutlineInputBorder(
            //               borderSide: BorderSide(color: AppColors.semiGreyColor),
            //               borderRadius: BorderRadius.circular(5),
            //             ),
            //             enabledBorder: OutlineInputBorder(
            //               borderSide: BorderSide(color: AppColors.semiGreyColor),
            //               borderRadius: BorderRadius.circular(5),
            //             ),
            //             disabledBorder: OutlineInputBorder(
            //               borderSide: BorderSide(color: AppColors.semiGreyColor),
            //               borderRadius: BorderRadius.circular(5),
            //             ),
            //             errorBorder: OutlineInputBorder(
            //               borderSide: BorderSide(color: AppColors.semiGreyColor),
            //               borderRadius: BorderRadius.circular(5),
            //             ),
            //           ),
            //           textStyle: GoogleFonts.poppins(color: Colors.white),
            //           numberOfFields: 6,
            //           enabledBorderColor: AppColors.semiGreyColor,
            //           disabledBorderColor: AppColors.semiGreyColor,
            //           focusedBorderColor: AppColors.semiGreyColor,
            //           cursorColor: AppColors.semiGreyColor,
            //           borderColor: AppColors.semiGreyColor,
            //           showFieldAsBox: true,
            //           autoFocus: false,
            //           borderWidth: 1,
            //           fieldWidth: 50,
            //           onCodeChanged: (String code) {},
            //           onSubmit: (String verificationCode) {
            //             registerOtp.otp = verificationCode;
            //             controller.otp = verificationCode;
            //             print(controller.otp);
            //           }, // end onSubmit
            //         ),
            //       ),
            //       SizedBox(height: height * 0.03),
            //       if (controller.timer != null && controller.timer!.isActive)
            //         Center(
            //           child: CommonText(
            //             content: "00:${controller.timerValue}",
            //             boldNess: FontWeight.w400,
            //           ),
            //         ),
            //       SizedBox(height: height * 0.03),
            //       if (controller.timer == null || !controller.timer!.isActive)
            //         InkWell(
            //           onTap: () {
            //             otpController.getOtp("resend");
            //             controller.manageTimer();
            //           },
            //           child: Column(
            //             children: [
            //               Center(
            //                 child: CommonText(
            //                   content: "Didn’t receive it?",
            //                   boldNess: FontWeight.w400,
            //                   textColor: AppColors.primaryColor,
            //                 ),
            //               ),
            //               SizedBox(height: height * 0.04),
            //               const Center(
            //                 child: CommonText(
            //                   content: "Resend OTP",
            //                   boldNess: FontWeight.w400,
            //                 ),
            //               ),
            //               SizedBox(height: height * 0.03),
            //             ],
            //           ),
            //         ),
            //       controller.isVerified == true
            //           ? Center(
            //               child: Container(
            //                 height: 35,
            //                 width: width / 3.8,
            //                 decoration: BoxDecoration(
            //                   color: Colors.green,
            //                   borderRadius: BorderRadius.circular(5),
            //                 ),
            //                 child: Center(
            //                   child: Row(
            //                     mainAxisSize: MainAxisSize.min,
            //                     children: [
            //                       const CircleAvatar(
            //                         radius: 10,
            //                         backgroundColor: Colors.white,
            //                         child: Center(
            //                           child: Icon(
            //                             Icons.done,
            //                             color: Colors.green,
            //                             size: 10,
            //                           ),
            //                         ),
            //                       ),
            //                       CommonText(
            //                         content: "  Verified",
            //                         textColor: Colors.white,
            //                         textSize: width * 0.03,
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //             )
            //           : controller.isVerified == null
            //               ? const SizedBox()
            //               : Center(
            //                   child: Container(
            //                     height: 35,
            //                     width: width / 3.8,
            //                     decoration: BoxDecoration(
            //                       color: Colors.white,
            //                       borderRadius: BorderRadius.circular(5),
            //                     ),
            //                     child: Center(
            //                       child: Row(
            //                         mainAxisSize: MainAxisSize.min,
            //                         children: [
            //                           const Icon(
            //                             Icons.error,
            //                             color: Colors.red,
            //                           ),
            //                           CommonText(
            //                             content: " Invalid OTP",
            //                             textColor: Colors.red,
            //                             textSize: width * 0.03,
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //       // SizedBox(height: height * 0.1),
            //       Spacer(),
            //       Obx(
            //         () => Padding(
            //           padding: const EdgeInsets.only(left: 20, right: 20),
            //           child: CommonPrimaryButton(
            //             isLoading: controller.isLoading.value,
            //             text: 'Verify Now',
            //             onTap: () async {
            //               await controller.verifyOtp().then((value) async {
            //                 if (value["type"] == "success") {
            //                   if (type == "mobile") {
            //                     await controller.mobileVerify().then((login) async {
            //                       await LocationService.instance.checkLocationPermission();
            //                       print("bodyMap <<<<<<<==>>$login");
            //                       await LocationService.instance.checkLocationPermission();
            //                       if (login != null) {
            //                         await controller.profileStatus(login['logInId']).then((value) async {
            //                           if (value != null) {
            //                             print("bodyMap  value<<<<<<<==>> $value");
            //                             await SharPreferences.setString(SharPreferences.loginId, login['logInId'] ?? "");
            //
            //                             print(">>>>>>>>>applicationStatus>>>>>>>${value['applicationStatus']}");
            //                             await SharPreferences.setString(
            //                                 SharPreferences.accessToken, "Bearer ${login['fcmToken']}" ?? "");
            //                             print(value['applicationStatus']);
            //                             if (value['applicationStatus'] == "Onboarded") {
            //                               await SharPreferences.setString(
            //                                   SharPreferences.storeCategoryId, value['storeCategoryId'] ?? "");
            //                               await SharPreferences.setString(
            //                                   SharPreferences.storeName, value['storeName'] ?? "");
            //                               await SharPreferences.setBoolean(SharPreferences.isLogin, true);
            //                               Get.offAll(() => const HomeScreen(), transition: Transition.size);
            //                             } else if (value['applicationStatus'] == "Pending") {
            //                               print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>${value['applicationStatus'] == "Pending"}");
            //                               Get.to(() => AppPendingScreen(), transition: Transition.size);
            //                             } else if (value['applicationStatus'] == "Rejected") {
            //                               Get.to(
            //                                   () => AppRejectedScreen(
            //                                       email: value['email'],
            //                                       password: value['password'],
            //                                       reasonReject: value["reason"] ?? {}),
            //                                   transition: Transition.size);
            //                             }
            //                           }
            //                         });
            //                       }
            //                     });
            //                   } else if (type == "register") {
            //                     await registerOtp.registerPost().then((register) {
            //                       print(">>>>>>>>>>>>>>>>register>>>>>>>>   $register");
            //                       if (register['status'] == true) {
            //                         Get.to(() => AppProcessScreen(), transition: Transition.size);
            //                       }
            //                     });
            //                   } else {
            //                     Get.to(() => AppProcessScreen(), transition: Transition.size);
            //                   }
            //                 }
            //               });
            //             },
            //           ),
            //         ),
            //       ),
            //       SizedBox(height: height * 0.01),
            //       Center(
            //         child: CommonText(
            //           textSize: width * 0.035,
            //           content: "Terms and Conditions applied Privacy policy",
            //         ),
            //       ),
            //       Center(
            //         child: CommonText(
            //           textSize: width * 0.035,
            //           content: "Privacy policy",
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ),
        ),
      ),
    );
  }
}
