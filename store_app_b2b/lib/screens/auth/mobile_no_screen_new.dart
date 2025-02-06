import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:store_app_b2b/components/common_phone_filed_new.dart';
import 'package:store_app_b2b/components/common_primary_button_new.dart';
import 'package:store_app_b2b/components/common_text_new.dart';
import 'package:store_app_b2b/components/common_text_field_new.dart';
import 'package:store_app_b2b/controllers/auth_controller/mobile_no_controller_new.dart';
import 'package:store_app_b2b/controllers/auth_controller/otp_controller_new.dart';
import 'package:store_app_b2b/screens/auth/otp_screen_new.dart';

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
                    content: "Enter mobile number",
                    hintText: "1234567890",
                    maxLength: 10,
                    inputFormatters: [LengthLimitingTextInputFormatter(10)],
                  ),
                  SizedBox(height: height * 0.3),
                  SizedBox(
                    height: height / 7,
                    child: Column(
                      children: [
                        CommonPrimaryButton(
                          text: "Continue",
                          onTap: () {
                            Get.to(() => OTPScreen(
                                type: "login",
                                mobile:
                                    mobileNoController.phoneController.text));
                          },
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
