import 'package:b2c/components/common_primary_button_new.dart';
import 'package:b2c/components/common_text_new.dart';
import 'package:b2c/constants/colors_const_new.dart';
import 'package:b2c/controllers/bank_details_controller_new.dart';
import 'package:b2c/utils/string_extensions_new.dart';
import 'package:b2c/widget/app_image_assets_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SocialOtpVerificationScreen extends StatelessWidget {
  final String phoneController;

  const SocialOtpVerificationScreen({super.key, required this.phoneController});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      body: GetBuilder<BankDetailsController>(
        builder: (BankDetailsController bankDetailsController) {
          return Stack(
            children: [
              AppImageAsset(
                  image: 'assets/image/bg.png',
                  height: height,
                  width: width,
                  fit: BoxFit.cover),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          CommonText(
                              content: "OTP has been sent to\n$phoneController",
                              textAlign: TextAlign.center),
                          SizedBox(height: height * 0.02),
                          SizedBox(
                            height: 55,
                            child: OtpTextField(
                              clearText: bankDetailsController.otp == ""
                                  ? true
                                  : false,
                              styles: const [
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
                              autoFocus: true,
                              borderWidth: 1,
                              fieldWidth: 50,
                              // onCodeChanged: (String code) => bankDetailsController.otp = bankDetailsController.otp+code,
                              onCodeChanged: (String code) {
                                logs(
                                    "logging onCodeChanged function ---> ${code}");
                                bankDetailsController.otp =
                                    bankDetailsController.otp + code;
                              },
                            ),
                          ),
                          SizedBox(height: height * 0.03),
                          // if (controller.timer != null && controller.timer!.isActive)
                          //   Center(
                          //     child: CommonText(
                          //       content: "00:${controller.timerValue.value.toString().padLeft(2, '0')}",
                          //       boldNess: FontWeight.w400,
                          //     ),
                          //   ),
                          // SizedBox(height: height * 0.03),
                          // if (controller.timer == null || !controller.timer!.isActive)
                          //   InkWell(
                          //     onTap: () {
                          //       otpController.getOtp("resend");
                          //       controller.manageTimer();
                          //     },
                          //     child: Column(
                          //       children: [
                          //         Center(
                          //           child: CommonText(
                          //             content: "Didn’t receive it?",
                          //             boldNess: FontWeight.w400,
                          //             textColor: AppColors.primaryColor,
                          //           ),
                          //         ),
                          //         SizedBox(height: height * 0.04),
                          //         const Center(
                          //           child: CommonText(
                          //             content: "Resend OTP",
                          //             boldNess: FontWeight.w400,
                          //           ),
                          //         ),
                          //         SizedBox(height: height * 0.03),
                          //       ],
                          //     ),
                          //   ),
                          // controller.isVerified == true
                          //     ? Center(
                          //         child: Container(
                          //           height: 35,
                          //           width: width / 3.8,
                          //           decoration: BoxDecoration(
                          //             color: Colors.green,
                          //             borderRadius: BorderRadius.circular(5),
                          //           ),
                          //           child: Center(
                          //             child: Row(
                          //               mainAxisSize: MainAxisSize.min,
                          //               children: [
                          //                 const CircleAvatar(
                          //                   radius: 10,
                          //                   backgroundColor: Colors.white,
                          //                   child: Center(
                          //                     child: Icon(
                          //                       Icons.done,
                          //                       color: Colors.green,
                          //                       size: 10,
                          //                     ),
                          //                   ),
                          //                 ),
                          //                 CommonText(
                          //                   content: "  Verified",
                          //                   textColor: Colors.white,
                          //                   textSize: width * 0.03,
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //         ),
                          //       )
                          //     : controller.isVerified == null
                          //         ? const SizedBox()
                          //         : Center(
                          //             child: Container(
                          //               height: 35,
                          //               width: width / 3.8,
                          //               decoration: BoxDecoration(
                          //                 color: Colors.white,
                          //                 borderRadius: BorderRadius.circular(5),
                          //               ),
                          //               child: Center(
                          //                 child: Row(
                          //                   mainAxisSize: MainAxisSize.min,
                          //                   children: [
                          //                     const Icon(
                          //                       Icons.error,
                          //                       color: Colors.red,
                          //                     ),
                          //                     CommonText(
                          //                       content: " Invalid OTP",
                          //                       textColor: Colors.red,
                          //                       textSize: width * 0.03,
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !keyboardIsOpen,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 20),
                      child: CommonPrimaryButton(
                        isLoading: false,
                        text: 'Verify Now',
                        onTap: () async =>
                            await bankDetailsController.verifyPhoneNumber(
                                phoneController, bankDetailsController.otp),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
