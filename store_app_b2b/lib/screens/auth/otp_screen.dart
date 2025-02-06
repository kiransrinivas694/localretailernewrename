import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app_b2b/components/common_primary_button.dart';
import 'package:store_app_b2b/components/common_text.dart';
import 'package:store_app_b2b/constants/colors_const.dart';
import 'package:store_app_b2b/controllers/auth_controller/login_controller.dart';
import 'package:store_app_b2b/controllers/auth_controller/otp_controller.dart';
import 'package:store_app_b2b/controllers/auth_controller/signup_controller.dart';
import 'package:store_app_b2b/screens/auth/app_process_screen.dart';
import 'package:store_app_b2b/screens/auth/supplier_onboard_screen.dart';
import 'package:store_app_b2b/utils/shar_preferences.dart';

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
    return SafeArea(
      child: Scaffold(
          body: GetBuilder<OTPController>(
        init: OTPController(),
        initState: (state) async {
          otpController.phoneController.text = mobile!;
          otpController.manageTimer();
          await otpController.getOtp("send");
        },
        builder: (controller) => Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/image/bg.png"),
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
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
                SizedBox(height: height * 0.18),
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
                          color: ColorsConst.appWhite,
                          fontWeight: FontWeight.w600),
                      TextStyle(
                          fontSize: 20,
                          color: ColorsConst.appWhite,
                          fontWeight: FontWeight.w600),
                      TextStyle(
                          fontSize: 20,
                          color: ColorsConst.appWhite,
                          fontWeight: FontWeight.w600),
                      TextStyle(
                          fontSize: 20,
                          color: ColorsConst.appWhite,
                          fontWeight: FontWeight.w600),
                      TextStyle(
                          fontSize: 20,
                          color: ColorsConst.appWhite,
                          fontWeight: FontWeight.w600),
                      TextStyle(
                          fontSize: 20,
                          color: ColorsConst.appWhite,
                          fontWeight: FontWeight.w600),
                    ],
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(bottom: 0),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ColorsConst.semiGreyColor),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ColorsConst.semiGreyColor),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ColorsConst.semiGreyColor),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ColorsConst.semiGreyColor),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    textStyle: GoogleFonts.poppins(color: Colors.white),
                    numberOfFields: 6,
                    enabledBorderColor: ColorsConst.semiGreyColor,
                    disabledBorderColor: ColorsConst.semiGreyColor,
                    focusedBorderColor: ColorsConst.semiGreyColor,
                    cursorColor: ColorsConst.semiGreyColor,
                    borderColor: ColorsConst.semiGreyColor,
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
                if (controller.timer != null && controller.timer!.isActive)
                  Center(
                    child: CommonText(
                      content: "00:${controller.timerValue}",
                      boldNess: FontWeight.w400,
                    ),
                  ),
                SizedBox(height: height * 0.03),
                if (controller.timer == null || !controller.timer!.isActive)
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
                            textColor: ColorsConst.primaryColor,
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
                            borderRadius: BorderRadius.circular(5),
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
                                borderRadius: BorderRadius.circular(5),
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
                SizedBox(height: height * 0.1),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: CommonPrimaryButton(
                    text: 'Verify Now',
                    onTap: () async {
                      await controller.verifyOtp().then((value) async {
                        if (value["type"] == "success") {
                          if (type == "register") {
                            await registerOtp
                                .registerPost()
                                .then((register) async {
                              print(
                                  "log current check >>>>>>>>>>>>>>>>value>>>>>>>>   $register");
                              if (register != null &&
                                  register['status'] == true) {
                                // Get.offAll(() => AppProcessScreen(),
                                //     transition: Transition.size);
                                Map<String, dynamic> result = register;
                                if (result.containsKey('loginId')) {
                                  await SharPreferences.setString(
                                      SharPreferences.storeCategoryMainId,
                                      register['categoryId'] ?? "");

                                  Get.offAll(() => SupplierOnboardScreen(
                                        retailerId: register["loginId"] ?? '',
                                      ));
                                }
                              }
                            });
                          } else {
                            Get.to(() => AppProcessScreen(),
                                transition: Transition.size);
                          }
                        }
                      });
                    },
                  ),
                ),
                SizedBox(height: height * 0.01),
                Center(
                  child: CommonText(
                    textSize: width * 0.035,
                    content: "Terms and Conditions applied Privacy policy",
                  ),
                ),
                Center(
                  child: CommonText(
                    textSize: width * 0.035,
                    content: "Privacy policy",
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
