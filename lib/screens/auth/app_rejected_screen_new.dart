import 'package:b2c/components/common_primary_button_new.dart';
import 'package:b2c/controllers/auth_controller/app_process_controller_new.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/common_text_new.dart';
import '../bottom_nav_bar/account_screens/account_screen_new.dart';

class AppRejectedScreen extends StatelessWidget {
  AppRejectedScreen(
      {Key? key, this.email, this.password, required this.reasonReject})
      : super(key: key);
  String? email = "";
  String? password = "";
  Map reasonReject = {};
  final AppProcessController appProcessController =
      Get.put(AppProcessController());
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
              SizedBox(height: height * 0.05),
              Center(
                child: SizedBox(
                  width: width / 1.3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CommonText(
                          content:
                              "Use the below details to login and check your status",
                          textSize: width * 0.035,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      // Row(
                      //   children: [
                      //     CommonText(
                      //       content: "Email : ",
                      //       textSize: width * 0.035,
                      //     ),
                      //     CommonText(
                      //         content: email,
                      //         textSize: width * 0.035,
                      //         textColor: ColorsConst.primaryColor),
                      //   ],
                      // ),
                      // Row(
                      //   children: [
                      //     CommonText(
                      //       content: "Password : ",
                      //       textSize: width * 0.035,
                      //     ),
                      //     CommonText(
                      //         content: password,
                      //         textSize: width * 0.035,
                      //         textColor: ColorsConst.primaryColor),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: height * 0.08),
              Center(child: Image.asset("assets/image/timer.png", scale: 4.5)),
              SizedBox(height: height * 0.1),
              Center(
                child: SizedBox(
                  width: width / 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        content: "Your application is Rejected",
                        textSize: width * 0.035,
                      ),
                      SizedBox(height: height * 0.02),
                      CommonText(
                        content: "Reason :",
                        textSize: width * 0.035,
                      ),
                      SizedBox(height: height * 0.01),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                            (reasonReject["reason"] ?? []).length, (index) {
                          return CommonText(
                            content: reasonReject["reason"][index],
                            textSize: width * 0.035,
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CommonPrimaryButton(
                    text: "Edit Profile",
                    onTap: () {
                      Get.to(() =>
                          ProfileScreen(screenType: "reject", isCallApi: true));
                    }),
              ),
              SizedBox(height: height * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
