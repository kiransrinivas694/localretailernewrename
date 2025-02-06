import 'package:b2c/components/common_primary_button_new.dart';
import 'package:b2c/components/common_text_new.dart';
import 'package:b2c/constants/colors_const_new.dart';
import 'package:b2c/controllers/GetHelperController_new.dart';
import 'package:b2c/controllers/bottom_controller/account_controllers/edit_account_controller_new.dart';
import 'package:b2c/controllers/home_controller_new.dart';
import 'package:b2c/screens/bottom_nav_bar/account_screens/account_screen_new.dart';
import 'package:b2c/screens/bottom_tap_bar_screen_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OTPEditScreen extends StatelessWidget {
  OTPEditScreen({Key? key, this.mobile}) : super(key: key);
  String? mobile = "";

  final otpController = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return SafeArea(
      child: Scaffold(
          body: GetBuilder<EditProfileController>(
        init: EditProfileController(),
        initState: (state) async {
          //otpController.phoneController.text = mobile!;
          otpController.manageTimer();
          await otpController.getOtp("send", number: mobile!);
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              Center(
                child: CommonText(
                  content: "ONE FINAL STEP...",
                  textSize: width * 0.055,
                  boldNess: FontWeight.w600,
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(height: height * 0.18),
                    Center(
                      child: CommonText(
                          content: "OTP has been sent to\n${mobile}"),
                    ),
                    SizedBox(height: height * 0.02),
                    OtpTextField(
                      styles: [
                        const TextStyle(
                            fontSize: 20,
                            color: AppColors.appWhite,
                            fontWeight: FontWeight.w600),
                        const TextStyle(
                            fontSize: 20,
                            color: AppColors.appWhite,
                            fontWeight: FontWeight.w600),
                        const TextStyle(
                            fontSize: 20,
                            color: AppColors.appWhite,
                            fontWeight: FontWeight.w600),
                        const TextStyle(
                            fontSize: 20,
                            color: AppColors.appWhite,
                            fontWeight: FontWeight.w600),
                        const TextStyle(
                            fontSize: 20,
                            color: AppColors.appWhite,
                            fontWeight: FontWeight.w600),
                        const TextStyle(
                            fontSize: 20,
                            color: AppColors.appWhite,
                            fontWeight: FontWeight.w600),
                      ],
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(bottom: 0),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.semiGreyColor),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.semiGreyColor),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.semiGreyColor),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.semiGreyColor),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      textStyle: GoogleFonts.poppins(color: Colors.white),
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
                        controller.otp = verificationCode;
                        print(controller.otp);
                      }, // end onSubmit
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
                  ],
                ),
              ),
              // SizedBox(height: height * 0.1),
              Visibility(
                visible: !keyboardIsOpen,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: CommonPrimaryButton(
                        text: 'Verify Now',
                        onTap: () async {
                          await controller
                              .verifyOtp(number: mobile)
                              .then((value) async {
                            if (value["type"] == "success") {
                              await controller
                                  .editProfilePostDataApi()
                                  .then((value) {
                                if (value != null) {
                                  // final controller = Get.put(HomeController());
                                  // controller.appBarTitle =
                                  //     GetHelperController.storeName.value;
                                  // controller.currentIndex = 4;
                                  // controller.currentWidget = ProfileScreen();
                                  // controller.update();
                                  // Get.offAll(() => const HomeScreen());
                                  Get.back();
                                  Get.back();
                                }
                              });
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
                    const SizedBox(height: 16)
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
