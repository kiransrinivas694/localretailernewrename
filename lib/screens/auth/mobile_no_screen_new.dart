import 'package:b2c/components/common_primary_button_new.dart';
import 'package:b2c/components/common_text_new.dart';
import 'package:b2c/components/common_text_field_new.dart';
import 'package:b2c/constants/colors_const_new.dart';
import 'package:b2c/controllers/auth_controller/mobile_no_controller_new.dart';
import 'package:b2c/screens/auth/otp_screen_new.dart';
import 'package:b2c/screens/auth/sign_up_screen_new.dart';
import 'package:b2c/utils/string_extensions_new.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/validation_utils_new.dart';

class MobileNoScreen extends StatelessWidget {
  MobileNoScreen({Key? key}) : super(key: key);
  final MobileNoController mobileNoController = Get.put(MobileNoController());

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
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
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: height / 5.7,
                    width: width / 1.3,
                    alignment: Alignment.topLeft,
                    child: Image.asset("assets/image/text.png"),
                  ),
                  SizedBox(height: height * 0.15),
                  CommonTextField(
                    controller: mobileNoController.phoneController,
                    content: "Enter store contact number",
                    hintText: "1234567890",
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    inputFormatters: [LengthLimitingTextInputFormatter(10)],
                  ),
                  SizedBox(height: height * 0.3),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "New to LOCAL ? ",
                        style: GoogleFonts.poppins(color: AppColors.hintColor),
                        children: [
                          TextSpan(
                            text: "Register",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(() => SignupScreen());
                              },
                            style: GoogleFonts.poppins(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: height / 7,
                    child: Column(
                      children: [
                        Obx(
                          () => CommonPrimaryButton(
                            isLoading: mobileNoController.isLoading.value,
                            text: "Continue",
                            onTap: () async {
                              if (ValidationUtils.instance.lengthValidator(
                                  mobileNoController.phoneController, 10)) {
                                'Enter store contact number'.showError();
                              } else {
                                await mobileNoController
                                    .signInPhoneNumber()
                                    .then(
                                  (value) {
                                    if (value['response'] == true) {
                                      Get.to(() => OTPScreen(
                                          type: "mobile",
                                          mobile: mobileNoController
                                              .phoneController.text));
                                    } else {
                                      "Phone Number is not registered.!"
                                          .showError();
                                    }
                                  },
                                );
                              }
                            },
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        CommonText(
                          content: "By continuing, you agree to our",
                          textSize: width * 0.032,
                        ),
                        CommonText(
                          content:
                              "Terms and Conditions applied. Privacy policy",
                          textSize: width * 0.032,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
